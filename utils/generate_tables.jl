include("../../ArithmeticNonStandarNumbersLibrary/src/BAN.jl")
using .BAN
include("../../Utils/src/io_matrix.jl")

function ban2latex(a)
	a==0 && return 0
	p = a.p
	res = "$(round(a.num[1]*1000)/1000)\\alpha^{$(p)}"
	for n in a.num[2:end]
		p -= 1
		if n>0
		res = string(res, " + ", round(n*1000)/1000, "\\alpha^{", p, "}")
		else
			res = string(res, round(n*1000)/1000, "\\alpha^{", p, "}")
		end
	end
	return res
end

function generate_table(benchmark, alg_names, medmath=false)
	if medmath
		throw(ArgumentError("Medmath version not implemented yet."))
	end
	
	P = []
	s = []
	open("performance/$(benchmark)/statistics.bin","r") do io
		P = read_matrix(io, Float64, Ban)
	end
	open("performance/$(benchmark)/num_solutions.bin","r") do io
		s = read_matrix(io, Float64, 1)
	end
	
	open("performance/$(benchmark)/latex_table.txt","w") do io
		println(io, "\\begin{table}[!ht]")
		println(io, "\\centering")
		println(io, "\\caption{Performance (\$\\Delta(\\cdot) = \\max\\{IGD(\\cdot), GD(\\cdot)\\}\$) on $(benchmark)}")
        println(io, "\t\\begin{tabular}{|c|c|c|c|}")
        println(io, "\t\t\\hline")
        println(io, "\t\t\\textbf{Algorithm} & \\textbf{Mean} & \\textbf{Std} & \\textbf{Number of Solutions}\\\\")
        println(io, "\t\t\\hline")
		for (alg_name, mean, std, sol) in zip(alg_names, P[:,1], P[:,2], s)
            println(io, string("\t\t", alg_name, " & \$", ban2latex(mean), "\$ & \$", ban2latex(std), "\$ & \$", round(sol*100)/100, "\$ \\\\"))
            println(io, "\t\t\\hline")
        end
		println(io, "\t\\end{tabular}")
		println(io, "\t\\label{tab:$(benchmark)_performance}")
        println(io, "\\end{table}")
	end
end
