struct Min end
struct Max end

function determine_domination!(pop, level_size::Vector{T}, minimize) where{T<:Integer}
	for i=1:nPop
        pop[i].dominated=false
    end

	tmp_pop = pop;
	pop_size = length(pop)

	for l in length(level_size)
		for i=1:pop_size
			for j=(i+1):pop_size
				if !tmp_pop[j].dominated && dominates(tmp_pop[i].cost[:,l],tmp_pop[j].cost[:,l], minimize)
					tmp_pop[j].dominated=true
				elseif !tmp_pop[i].dominated && dominates(tmp_pop[j].cost[:,l],tmp_pop[i].cost[:,l], minimize)
					tmp_pop[i].dominated=true   
				end
			end
		end
		tmp_pop = tmp_pop[map(x->x.dominated==false, tmp_pop)];
		pop_size = length(tmp_pop);
	end
end

function dominates(cost1::Matrix{T}, cost2::Matrix{T}, ::Min) where{T<:Real}
	diff = cost1-cost2
	return (all(x->x<=0, diff) && any(x->x<0, diff))
end

function dominates(cost1::Matrix{T}, cost2::Matrix{T}, ::Max) where{T<:Real}
	diff = cost1-cost2
	return (all(x->x>=0, diff) && any(x->x>0, diff))
end
