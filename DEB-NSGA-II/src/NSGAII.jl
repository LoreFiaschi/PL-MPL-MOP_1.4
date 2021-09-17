__precompile__()
module DEB_PLNSGAII

export nsga, nsga_max, nsga_binary, BinaryCoding, dominates#, offspring, parents
using ProgressMeter, Random

include("indivs.jl")
include("binarycoding.jl")
include("functions.jl")
include("crossover.jl")
include("mutation.jl")

function nsga(popSize::Integer, nbGen::Integer, z::Function, init::Function ;
    fdecode = identity, fdecode! = (g,p)-> (p.=g;nothing), fCV = x->0., pmut = 0.05, fmut = default_mutation!,
    fcross = default_crossover!, τ = 0.1, seed = typeof(init())[], fplot = x->nothing, plotevery = 1, showprogress = true)
	X = create_indiv(init(), fdecode, z, fCV)
    return _nsga(X, Min(), popSize, nbGen, init, z, fdecode, fdecode!,
        fCV , pmut, fmut, fcross, τ, seed, fplot, plotevery, showprogress ? 0.5 : Inf)
end

function nsga(popSize::Integer, nbGen::Integer, z::Function, bc::BinaryCoding ;
    fCV = x->0., pmut = 0.05, fmut = default_mutation!, fcross = default_crossover!, τ = 0.1,
    seed = Vector{Float64}[], fplot = x->nothing, plotevery = 1, showprogress = true)
    init = ()->rand(Bool, bc.nbbitstotal)
    X = create_indiv(init(), x->decode(x, bc), z, fCV)
    return _nsga(X, Min(), popSize, nbGen, init, z, x->decode(x, bc), (g,f)->decode!(g, bc, f),
        fCV , pmut, fmut, fcross, τ, encode(seed, bc), fplot, plotevery, showprogress ? 0.5 : Inf, binarycoding = bc)
end

function nsga_max(popSize::Integer, nbGen::Integer, z::Function, init::Function ;
    fdecode = identity, fdecode! = (g,p)-> (p.=g;nothing), fCV = x->0., pmut = 0.05, fmut = default_mutation!,
    fcross = default_crossover!, τ = 0.1, seed = typeof(init())[], fplot = x->nothing, plotevery = 1, showprogress = true)
	X = create_indiv(init(), fdecode, z, fCV)
    return _nsga(X, Max(), popSize, nbGen, init, z, fdecode, fdecode!,
        fCV , pmut, fmut, fcross, τ, seed, fplot, plotevery, showprogress ? 0.5 : Inf)
end

function nsga_max(popSize::Integer, nbGen::Integer, z::Function, bc::BinaryCoding ;
    fCV = x->0., pmut = 0.05, fmut = default_mutation!, fcross = default_crossover!, τ = 0.1,
    seed = Vector{Float64}[], fplot = x->nothing, plotevery = 1, showprogress = true)
    init = ()->rand(Bool,bc.nbbitstotal)
    X = create_indiv(init(), x->decode(x, bc), z, fCV)
    return _nsga(X, Max(), popSize, nbGen, init, z, x->decode(x, bc), (g,f)->decode!(g, bc, f),
        fCV , pmut, fmut, fcross, τ, encode(seed, bc), fplot, plotevery, showprogress ? 0.5 : Inf, binarycoding = bc)
end

end # module
