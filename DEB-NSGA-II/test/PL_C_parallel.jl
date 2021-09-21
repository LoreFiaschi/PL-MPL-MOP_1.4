@everywhere include("DEB-NSGA-II/test/PL_C.jl")

num_trials = 4
trial = ["outputs/DEB-NSGA-II/PL_C_$(i).bin" for i=1:num_trials]

pmap(PL_C, trial)

nothing
