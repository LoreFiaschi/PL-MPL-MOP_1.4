function ban2latex(a)

end

function generate_table(benchmark, alg_names, medmath=false)
	if medmath
		throw(ArgumentError("Medmath version not implemented yet."))
	end
	
	P = []
	s = []
	open("performance/$(benchmark)/statistics.bin","r") do io
		P = read_matrix(io, Float64)
	end
	open("performance/$(benchmark)/num_solutions.bin","r") do io
		s = read_matrix(io, dims=1, Int64)
	end
	
	open("performance/$(benchmark)/latex_table.bin","w") do io
		println(io, "\\begin{table}[!htp]")
		println(file, "\\centering")
        println(file, "\t\\begin{tabulary}{\\linewidth}{|c|c|c|c|}")
        println(file, "\t\t\\hline")
        println(file, "\t\tAlgorithm & Mean & Std & Number of Solutions\\\\")
        println(file, "\t\t\\hline")
        println(file, string("\t\t", alg_names[1], " & \$", ban2latex(p[1,1]), "\$ & \$", ban2latex(p[1,2]), "\$ & \$", s[1], "\$ \\\\"))
	end
end
