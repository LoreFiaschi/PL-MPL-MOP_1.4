include("../ArithmeticNonStandarNumbersLibrary/src/BAN.jl")
using .BAN
include("../Utils/src/io_matrix.jl")

function show_performance(benchmark)
	open("performance/$(benchmark)/statistics.bin", "r") do io
		P = read_matrix(io, Float64)
		println("Means:")
		println(P[:,1])
		println("")
		println("Stds:")
		println(P[:,2])
	end
end