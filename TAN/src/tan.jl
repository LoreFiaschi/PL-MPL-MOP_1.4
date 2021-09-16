__precompile__()
module TAN

include("indivs.jl")
include("../../utils/binarycoding.jl")
include("../../utils/crossover.jl")
include("../../utils/mutation.jl")

using ProgressMeter, Random
export tan, BinaryCoding, Min, Max

struct Min end
struct Max end

function tan(popSize::Integer, sense, priorities::Vector{T}, max_it::Integer, 
	z::Function, bc::BinaryCoding; fCV = x->0., pmut = 0.05, fmut = default_mutation!, 
	fcross = default_crossover!, seed = Vector{Float64}[], fplot = x->nothing, plotevery = 1,
	showprogress = true) where T<:Integer

    init = ()->rand(Bool, bc.nbbitstotal)
 	
	return _tan(popSize, sense, priorities, max_it, z, init, x->decode(x,bc), (x,y)->decode!(x,bc,y),
			fCV, pmut, fmut, fcross, encode(seed,bc), fplot, plotevery, showprogress ? 0.5 : Inf, binarycoding = bc)
end

function _tan(pop_size::Integer, sense, priorities::Vector{T}, max_it::Integer, z::Function,
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

end

end
