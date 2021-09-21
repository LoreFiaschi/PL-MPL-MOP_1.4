@everywhere include("DEB-NSGA-II/test/PL_A.jl")

num_trials = 4
trial = ["outputs/DEB-NSGA-II/PL_A_$(i).bin" for i=1:num_trials]

pmap(PL_A, trial)

nothing
