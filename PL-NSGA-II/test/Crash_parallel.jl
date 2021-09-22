@everywhere include("PL-NSGA-II/test/Crash.jl")

num_trials = 50
trial = ["outputs/PL-NSGA-II/Crash_$(i).bin" for i=1:num_trials]

pmap(Crash, trial)

nothing
