@everywhere include("PL-NSGA-II/test/PL_A.jl")

num_trials = 50
trial = ["outputs/PL-NSGA-II/PL_A_$(i).bin" for i=1:num_trials]

pmap(PL_A, trial)

nothing
