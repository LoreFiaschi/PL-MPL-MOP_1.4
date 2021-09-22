@everywhere include("SCHMIEDLE/test/MaF11.jl")

num_trials = 50
trial = ["outputs/SCHMIEDLE/MaF11_$(i).bin" for i=1:num_trials]

pmap(MaF11, trial)

nothing
