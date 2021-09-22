@everywhere include("SCHMIEDLE/test/PL_C.jl")

num_trials = 50
trial = ["outputs/SCHMIEDLE/PL_C_$(i).bin" for i=1:num_trials]

pmap(PL_C, trial)

nothing
