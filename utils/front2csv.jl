include("io.jl")
using DataFrames, CSV

function save2csv(algorithm, benchmark, number)
	F = load_front("outputs/$(algorithm)/$(benchmark)_$(number).bin")
	F = map(x->x[:,1], F)
	df = DataFrame(hcat(F...)')
	CSV.write("fronts/$(benchmark)_$(algorithm).csv", df, header=false)
end

#save2csv("MOEAD", "MaF7", 2)
#save2csv("SCHMIEDLE", "MaF11", 1)
save2csv("MOEAD", "MaF11", 2)
