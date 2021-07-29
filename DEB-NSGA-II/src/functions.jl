function _nsga(::indiv{G,Ph,Y,C}, sense, popSize, nbGen, init, z, fdecode, fdecode!,
    fCV , pmut, fmut, fcross, τ, seed, fplot, plotevery, refreshtime;
    binarycoding::BinaryCoding=nothing)::Vector{indiv{G,Ph,Y,C}} where {G,Ph,Y,C}

	τ<0 && throw(ArgumentError("τ must be a positive number, $(τ) given"))

    popSize = max(popSize, length(seed))
    isodd(popSize) && (popSize += 1)
    P = Vector{indiv{G,Ph,Y,C}}(undef, 2*popSize)
    P[1:popSize-length(seed)] .= [create_indiv(init(), fdecode, z, fCV) for _=1:popSize-length(seed)]
    for i = 1:length(seed)
        P[popSize-length(seed)+i] = create_indiv(convert(G, seed[i]), fdecode, z, fCV)
    end
    for i=1:popSize
        P[popSize+i] = deepcopy(P[i])
    end

	lowestpower = size(P[1].y, 2) #lowest power

    #this call to fast_non_dominated_sort is necessary for tournament selection
    PL_fast_non_dominated_sort!(view(P, 1:popSize), sense, lowestpower, τ)

    @showprogress refreshtime for gen = 1:nbGen

        for i = 1:2:popSize

            pa = tournament_selection(P, popSize, τ)
            pb = tournament_selection(P, popSize, τ)

            crossover!(pa, pb, fcross, P[popSize+i], P[popSize+i+1], binarycoding)

            rand() < pmut && mutate!(P[popSize+i], binarycoding, fmut)
            rand() < pmut && mutate!(P[popSize+i+1], binarycoding, fmut)

            eval!(P[popSize+i], fdecode!, z, fCV)
            eval!(P[popSize+i+1], fdecode!, z, fCV)
        end

		PL_fast_non_dominated_sort!(P, sense, lowestpower, τ)
		
		current_front = 1;
		ind_start = 1;
		ind_end = 1;
		while true
			if ind_end < 2*popSize && P[ind_end].rank == P[ind_end+1].rank									# if the consecutive individuals belong to the same front
				ind_end += 1;
			else 																	# the front is ended
				PL_crowding_distance!(view(P, ind_start:ind_end))
				for i=ind_start:ind_end 											# update the rank information
					P[i].rank = current_front; 
				end
				current_front +=1;
				if ind_end > popSize                      							# need to choose part of the first front which does not fit
					shuffle!(view(P, ind_start:ind_end))    						# prevents asymmetries in the choice
					sort!(view(P, ind_start:ind_end), by = x -> x.crowding, rev=true, alg=PartialQuickSort(popSize-ind_start+1))
					break 															# stop filling next population
				end
				ind_end == popSize && break											# stop filling next population
				ind_end += 1;
				ind_start = ind_end;
			end
		end
			
        #gen == plotevery && println("Loading plot...")
        #gen % plotevery == 0 && fplot(P, gen)
    end

    #fplot(P, nbGen)
    view(P, 1:popSize)  #returns the first half of array (dominated and not)
   
end

function fast_non_dominated_sort!(pop::AbstractVector{T}, sense, gp::Int, firstrank::Int, τ) where {T}
    n = length(pop)

    for p in pop
        empty!(p.dom_list)
        p.dom_count = 0
        p.rank = firstrank - 1
    end

    @inbounds for i in 1:n
        for j in i+1:n
            if dominates(sense, pop[i], pop[j], gp, τ)
                push!(pop[i].dom_list, j)
                pop[j].dom_count += 1
            elseif dominates(sense, pop[j], pop[i], gp, τ)
                push!(pop[j].dom_list, i)
                pop[i].dom_count += 1
            end
        end
        if pop[i].dom_count == 0
            pop[i].rank = firstrank
        end
    end

    k = UInt16(firstrank + 1)
    @inbounds while any(==(k-one(UInt16)), (p.rank for p in pop)) #ugly workaround for #15276
        for p in pop
            if p.rank == k-one(UInt16)
                for q in p.dom_list
                    pop[q].dom_count -= one(UInt16)
                    if pop[q].dom_count == zero(UInt16)
                        pop[q].rank = k
                    end
                end
            end
        end
        k += one(UInt16)
    end
    sort!(pop, by = x->x.rank, alg=Base.Sort.QuickSort)
    return k-UInt16(2)    #last rank assigned
end

function PL_fast_non_dominated_sort!(pop::AbstractVector{T}, sense, minpower::Int, τ) where {T}
    n = length(pop)
    for ind in pop      #initialize all ranks to 1
        ind.rank = 1
    end
    glob_highest_rank = 1
    for gp in 1:minpower
        ind = 1
        last_rank_used = 0
        for i in 1:glob_highest_rank
            nextind = findfirst(x->x.rank==i+1, view(pop, ind:n))
            if nextind == nothing
                nextind = n+1
			else
				nextind += ind - 1
            end
            last_rank_used = fast_non_dominated_sort!(view(pop, ind:nextind-1), sense, gp, last_rank_used+1, τ)
            ind = nextind
        end
        glob_highest_rank = last_rank_used
    end
end

function PL_crowding_distance!(pop::AbstractVector{indiv{X,G,Y,C}}) where {X, G, Y, C}
    for ind in pop      #zero-out crowding distance
        for p in eachindex(ind.crowding)
            ind.crowding[p] = 0.
        end
    end

    for p in eachindex(first(pop).crowding)     # Foreach level of priority
        @inbounds for j = 1:size(first(pop).y,1)         # Foreach objective in this priority level
            let j = j #https://github.com/JuliaLang/julia/issues/15276
                sort!(pop, by = x-> x.y[j,p])      #sort by the objective value
            end
            pop[1].crowding[p] = pop[end].crowding[p] = Inf
            if pop[1].y[j,p] != pop[end].y[j,p]
                for i = 2:length(pop)-1
                    pop[i].crowding[p] += (pop[i+1].y[j,p]-pop[i-1].y[j,p]) / (pop[end].y[j,p]-pop[1].y[j,p])
                end
            end
        end
    end
	nothing
end

function tournament_selection(P, popSize, τ)
    a, b = rand(1:popSize), rand(1:popSize)
    if better(P[a], P[b], τ)      #return the best one (crowded comparison operator)
		return P[a]
    elseif better(P[b], P[a], τ)
        return P[b]
	end
    return rand(Bool) ? P[a] : P[b]    #choose randomly if they're equal
end
