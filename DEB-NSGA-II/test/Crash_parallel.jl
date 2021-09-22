@everywhere include("DEB-NSGA-II/test/Crash.jl")

num_trials = 50
trial = ["outputs/DEB-NSGA-II/Crash_$(i).bin" for i=1:num_trials]

pmap(Crash, trial)

nothing
