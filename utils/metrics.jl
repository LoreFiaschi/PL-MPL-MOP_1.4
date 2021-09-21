# WARNING: the objectives is a Matrix where each column is a level. Shoerter levels are padded by zero from bottom

__precompile__()
module metrics

include("../../ArithmeticNonStandarNumbersLibrary/src/BAN.jl")
include("domination.jl")
#include("definitions.jl")

using .BAN
export delta_metric
export Min, Max

mutable struct Individual

    cost::Matrix{T} where {T<:Real}
    dominated::Bool
    pop_idx::S where {S<:Integer}
end

function preprocess!(pop_array::Vector{Vector{Matrix{T}}}, level_size::Vector{S}) where {T<:Real,S<:Integer}
	newpop_array = Vector{Vector{Individual}}(undef, length(pop_array))
	for i in eachindex(pop_array)
        #deletion of duplicates
        pop_array[i] = unique(pop_array[i])
        pop_size = length(pop_array[i])
        newpop_array[i] = Vector{Individual}(undef, pop_size)
        for j=1:pop_size
            newpop_array[i][j] = Individual(pop_array[i][j], false, i)
        end
    end
	whole_pop = convert(Array{Individual, 1}, []) # no ways to improve it? 
    for i in eachindex(newpop_array)
        whole_pop = [whole_pop ; newpop_array[i]]
    end
	# Normaliztion
	for i=1:length(level_size)
		for j=1:level_size[i]
			M = maximum(map(x->x.cost[i,j], whole_pop))
			m = minimum(map(x->x.cost[i,j], whole_pop))
			width = M-m;
			for h in eachindex(whole_pop)
				whole_pop[h].cost[i,j] /= width;
			end
		end
	end
    return newpop_array, whole_pop
end

function compute_distance(z::Matrix{T}, x::Matrix{T}, ::Min, ishibuchi::Bool=false) where{T<:Real}
	return _compute_distance(x-z, ishibuchi)
end

function compute_distance(z::Matrix{T}, x::Matrix{T}, ::Max, ishibuchi::Bool=false) where{T<:Real}
	return _compute_distance(z-x, ishibuchi)
end

function _compute_distance(diff::Matrix{T}, ishibuchi::Bool=false) where{T<:Real}
	if ishibuchi
        throw(ArgumentError("Ishibuci version not implemented yet"))
    end
	num_levels = size(diff,2)
	d = Vector{T}(undef, num_levels)
	for i=1:num_levels
		d[i] = dot(diff[:,i],diff[:,i])
	end
    return Ban(0,d)
end

function compute_GD_performance(pop::Vector{Individual}, true_pareto::Vector{Individual}, sense, ishibuchi::Bool=false)
    performance = 0
    for ind in pop
        if ind.dominated
            min_dist = Inf
            for true_ind in true_pareto
                dist = compute_distance(true_ind.cost, ind.cost, sense, ishibuchi)
                if dist < min_dist
                    min_dist = dist
                    if min_dist == 0
                        break
                    end
                end
            end
            performance += min_dist
        end
    end
    return performance/length(pop)
end

function compute_IGD_performance(pop::Vector{Individual}, true_pareto::Vector{Individual}, pop_idx::T, sense, ishibuchi::Bool=false) where{T<:Integer}
    performance =  0
    for true_ind in true_pareto
        if pop_idx != true_ind.pop_idx
            min_dist = Inf
            for ind in pop
                dist = compute_distance(true_ind.cost, ind.cost, sense, ishibuchi)
                if dist < min_dist
                    min_dist = dist
                    if min_dist == 0
                        break
                    end
                end
            end
            performance += min_dist
        end
    end
    return performance/length(true_pareto)
end

function _delta_metric(pop_array::Vector{Vector{Matrix{T}}}, level_size::Vector{S}, sense, separated::Bool=false, ishibuchi::Bool=false) where {T<:Real,S<:Integer}
    pop_array, whole_pop = preprocess!(pop_array, level_size)
    determine_domination!(whole_pop, level_size, sense) #Notice: domination information is added also in pop_array
    true_pareto = whole_pop[map(x->~x.dominated, whole_pop)]

	if separated
		num_pop = length(pop_array)
	    performance_vector_Delta = Vector{Ban}(undef, num_pop)
	    performance_vector_GD = Vector{Ban}(undef, num_pop)
	    performance_vector_IGD = Vector{Ban}(undef, num_pop)
		for i in eachindex(pop_array)
			performance_vector_GD[i] = compute_GD_performance(pop_array[i], true_pareto, sense, ishibuchi)
			performance_vector_IGD[i] = compute_IGD_performance(pop_array[i], true_pareto, i, sense, ishibuchi)
			performance_vector_Delta[i] = max(performance_vector_GD[i], performance_vector_IGD[i])
		end
		return performance_vector_Delta, performance_vector_GD, performance_vector_IGD
	end

	# if not separated
    performance_vector = Vector{Ban}(undef, length(pop_array))
	for i in eachindex(pop_array)
	    performance_vector[i] = compute_GD_performance(pop_array[i], true_pareto, sense, ishibuchi)
	    igd_performance = compute_IGD_performance(pop_array[i], true_pareto, i, sense, ishibuchi)
	    performance_vector[i] = (igd_performance > performance_vector[i]) ? igd_performance : performance_vector[i]
	end
	return performance_vector
end

delta_metric(pop_array::Vector{Vector{Matrix{T}}}, level_size::Vector{S}, sense, separated::Bool=false, ishibuchi::Bool=false) where {T<:Real,S<:Integer} = _delta_metric(pop_array, level_size, sense, separated, ishibuchi)
end #module
