__precompile__()
module SCHMIEDLE

# TODO 

include("favoring.jl")
include("indivs.jl")
include("../../utils/binarycoding.jl")
include("../../utils/crossover.jl")
include("../../utils/mutation.jl")

using LightGraphs, ProgressMeter, Random
export schmiedle, BinaryCoding, Min, Max

struct Min end
struct Max end

function schmiedle(popSize::Integer, sense, priorities::Vector{T}, max_it::Integer, 
	z::Function, bc::BinaryCoding; fCV = x->0., pmut = 0.05, fmut = default_mutation!, 
	fcross = default_crossover!, seed = Vector{Float64}[], fplot = x->nothing, plotevery = 1,
	showprogress = true) where T<:Integer

    init = ()->rand(Bool, bc.nbbitstotal)
 	
	return _schmiedle(popSize, sense, priorities, max_it, z, init, x->decode(x,bc), (x,y)->decode!(x,bc,y),
			fCV, pmut, fmut, fcross, encode(seed,bc), fplot, plotevery, showprogress ? 0.5 : Inf, binarycoding = bc)
end

function _schmiedle(pop_size::Integer, sense, priorities::Vector{T}, max_it::Integer, z::Function,
	init::Function,	fdecode, fdecode!, fCV, pmut, fmut, fcross, seed, fplot, plotevery, refreshtime;
	binarycoding::BinaryCoding=nothing) where T<:Integer

	type_x  = typeof(init()) # needed for warm starts

    pop_size = max(pop_size, length(seed))
    isodd(pop_size) && (pop_size += 1)
    P = Vector{indiv}(undef, 2*pop_size)
    P[1:pop_size-length(seed)] .= [create_indiv(init(), fdecode, z, fCV) for _=1:pop_size-length(seed)]
    for i = 1:length(seed)
        P[pop_size-length(seed)+i] = create_indiv(convert(type_x, seed[i]), fdecode, z, fCV)
    end
    for i=1:pop_size
        P[pop_size+i] = deepcopy(P[i])
    end
    
    determine_favoring!(P, priorities)
	sort!(P, by = x->x.fitness, rev = true) # needed by tournament selection
    
	@showprogress refreshtime for it=1:max_it
    
		for i = 1:2:pop_size

            pa = tournament_selection(P, pop_size)
            pb = tournament_selection(P, pop_size)

            crossover!(pa, pb, fcross, P[pop_size+i], P[pop_size+i+1], binarycoding)

            rand() < pmut && mutate!(P[pop_size+i], binarycoding, fmut)
            rand() < pmut && mutate!(P[pop_size+i+1], binarycoding, fmut)

            eval!(P[pop_size+i], fdecode!, z, fCV)
            eval!(P[pop_size+i+1], fdecode!, z, fCV)
        end

        sort!(P, by = x->x.fitness, rev = true)
        
        determine_favoring!(P, priorities)
		sort!(P, by = x->x.fitness, rev = true)

		# Random selection of those exceeding the pop size
		if P[pop_size].fitness == P[pop_size+1].fitness
			idx_first = findfirst(x->(x.fitness == P[pop_size].fitness), P)
			idx_last = findlast(x->(x.fitness == P[pop_size].fitness), P)
			shuffle!(view(P, idx_first:idx_last))
			sort!(view(P, idx_first:idx_last), by = x->x.fitness, rev=true, alg=PartialQuickSort(pop_size-idx_first+1))
		end

    end
    
    return view(P, 1:pop_size)
end
end
