@everywhere include("DEB-NSGA-II/test/MaF7.jl")

num_trials = 50
trial = ["outputs/DEB-NSGA-II/MaF7_$(i).bin" for i=1:num_trials]

pmap(MaF7, trial)

nothing
