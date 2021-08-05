include("../src/favoring.jl")
include("../src/indivs.jl")
include("../../utils/binarycoding.jl")
include("../../utils/crossover.jl")
include("../../utils/mutation.jl")

using LightGraphs, ProgressMeter, Random

const bc = BinaryCoding(5, [0.0, 0.0, 0.0], [5.0, 5.0, 5.0]);

priorities = [1,3]
seed = [[2, 6, 0, 8], [2, 7, 8, 9], [2, 8, 8, 8], [5, 6, 0, 8], [5, 7, 5, 1], [5, 2, 7, 5]]
shuffle!(seed)

P = Vector{indiv}(undef, length(seed))

for i=1:length(seed)
	P[i] = indiv(encode(seed[i],bc), seed[i], seed[i], 0)
end

determine_favoring!(P, priorities)
sort!(P, by = x->x.fitness, rev = true) # needed by tournament selection

for p in P
	print(p.y); print("   "); println(p.fitness)
	println("")
end
