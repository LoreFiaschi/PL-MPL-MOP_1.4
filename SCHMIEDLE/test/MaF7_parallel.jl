@everywhere include("SCHMIEDLE/test/MaF7.jl")

num_trials = 50
trial = ["outputs/SCHMIEDLE/MaF7_$(i).bin" for i=1:num_trials]

pmap(MaF7, trial)

nothing
