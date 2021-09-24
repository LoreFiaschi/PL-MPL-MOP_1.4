include("../ArithmeticNonStandarNumbersLibrary/src/BAN.jl")
using .BAN
include("../Utils/src/io_matrix.jl")

function show_performance(benchmark)
	open("performance/$(benchmark)/statistics.bin", "r") do io
		P = read_matrix(io, Float64, Ban)
		println("Means:")
		println(P[:,1])
		println("")
		println("Stds:")
		println(P[:,2])
		println("")
	end
	open("performance/$(benchmark)/num_solutions.bin", "r") do io
		s = read_matrix(io, Float64, 1)
		println("Num solutions:")
		println(s)
	end
end
