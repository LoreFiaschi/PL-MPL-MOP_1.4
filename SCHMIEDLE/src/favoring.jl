# Create and return the favoring relation as a graph 
function determine_favoring!(population, priorities::Vector{T}) where T<:Integer

    pop_size = length(population)
    G = SimpleDiGraph(pop_size,0)
    
    for i=1:pop_size
        for j=(i+1):pop_size
            favoring = favored(population[i], population[j], priorities)
            favoring > 0 && add_edge!(G, i, j)
            favoring < 0 && add_edge!(G, j, i)
        end
    end

	SCC = strongly_connected_components(G)
    MG = ComputeMetaGraph(SCC, population, priorities)

	for i=1:length(SCC)
        inneigh = inneighbors(MG,i)
        population[i].fitness = length(SCC)-length(inneigh) #higher shared_fitness higher quality, lower inneigh higher quality
    end
end

# Implements the prioritized favoring relation
function favored(ind1, ind2, priorities::Vector{T}) where T<:Integer

    ind1.CV != ind2.CV && return ind2.CV-ind1.CV

    cost1 = ind1.y
    cost2 = ind2.y

    num_priorities = length(priorities)
    
    for i=1:num_priorities
        favoring = isFavored(cost1[(sum(priorities[1:(i-1)])+1):sum(priorities[1:i])], cost2[(sum(priorities[1:(i-1)])+1):sum(priorities[1:i])])
        favoring > 0 && return favoring
        favoring < 0 && return favoring
    end
    return 0
end


# Implements the favoring relation
function isFavored(cost1, cost2)

    diff = cost1-cost2
    return count(x->x<0, diff)-count(x->x>0, diff)
end

function ComputeMetaGraph(SCC, population, priorities::Vector{T}) where T<:Integer
    
    numComponents = length(SCC)
    G = SimpleDiGraph(numComponents,0)
    
    for i=1:numComponents
        for j=i+1:numComponents
            favoring = favored(population[SCC[i][1]], population[SCC[j][1]], priorities)
            favoring > 0 && add_edge!(G, i, j)
            favoring < 0 && add_edge!(G, j, i)
        end
    end
    
    return G
end
