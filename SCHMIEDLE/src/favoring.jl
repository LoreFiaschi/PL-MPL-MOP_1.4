struct Min end
struct Max end

# Create and return the favoring relation as a graph 
function determine_favoring!(population, priorities::Vector{T}, num_priorities::T, sense) where T<:Integer

    pop_size = length(population)
    G = SimpleDiGraph(pop_size,0)
    
    for i=1:pop_size
        for j=(i+1):pop_size
            favoring = favored(population[i], population[j], priorities, num_priorities, sense)
            favoring > 0 && add_edge!(G, i, j)
            favoring < 0 && add_edge!(G, j, i)
        end
    end

	SCC = strongly_connected_components(G)
	numComponents = length(SCC)
    MG = ComputeMetaGraph(SCC, numComponents, population, priorities, num_priorities, sense)

	for i=1:numComponents
        inneigh = length(inneighbors(MG,i))
		for j=1:length(SCC[i])
        	population[SCC[i][j]].fitness = inneigh #lower fitness higher quality, lower inneigh higher quality
		end
    end
end

# Implements the prioritized favoring relation
function favored(ind1, ind2, priorities::Vector{T}, num_priorities::T, sense) where T<:Integer

    ind1.CV != ind2.CV && return ind2.CV-ind1.CV

    cost1 = ind1.y
    cost2 = ind2.y
    
    for i=1:num_priorities
        favoring = isFavored(cost1[(sum(priorities[1:(i-1)])+1):sum(priorities[1:i])], cost2[(sum(priorities[1:(i-1)])+1):sum(priorities[1:i])], sense)
        favoring != 0 && return favoring
    end
    return 0
end


# Implements the favoring relation
function isFavored(cost1, cost2, ::Min)

    diff = cost1-cost2
    return count(x->x<0, diff)-count(x->x>0, diff)
end

function isFavored(cost1, cost2, ::Max)

    diff = cost1-cost2
    return count(x->x>0, diff)-count(x->x<0, diff)
end



function ComputeMetaGraph(SCC, numComponents::T, population, priorities::Vector{T}, num_priorities::T, sense) where T<:Integer
    
    G = SimpleDiGraph(numComponents,0)
    
    for i=1:numComponents
        for j=i+1:numComponents
            favoring = favored(population[SCC[i][1]], population[SCC[j][1]], priorities, num_priorities, sense)
            favoring > 0 && add_edge!(G, i, j)
            favoring < 0 && add_edge!(G, j, i)
        end
    end
    
    return G
end
