@everywhere include("SCHMIEDLE/test/PL_A.jl")

num_trials = 50
trial = ["outputs/SCHMIEDLE/PL_A_$(i).bin" for i=1:num_trials]

pmap(PL_A, trial)

nothing
