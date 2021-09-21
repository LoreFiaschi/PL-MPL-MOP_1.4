@everywhere include("SCHMIEDLE/test/Crash.jl")

num_trials = 4
trial = ["outputs/SCHMIEDLE/Crash_$(i).bin" for i=1:num_trials]

pmap(Crash, trial)

nothing
