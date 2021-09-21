@everywhere include("DEB-NSGA-II/test/PL_B.jl")

num_trials = 4
trial = ["outputs/DEB-NSGA-II/PL_B_$(i).bin" for i=1:num_trials]

pmap(PL_B, trial)

nothing
