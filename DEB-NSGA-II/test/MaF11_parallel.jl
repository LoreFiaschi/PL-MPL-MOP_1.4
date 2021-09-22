@everywhere include("DEB-NSGA-II/test/MaF11.jl")

num_trials = 50
trial = ["outputs/DEB-NSGA-II/MaF11_$(i).bin" for i=1:num_trials]

pmap(MaF11, trial)

nothing
