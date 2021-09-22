include("../src/schmiedle.jl")
include("../../utils/io.jl")

using .SCHMIEDLE
using PyPlot

const bc = BinaryCoding(5, [0.0, 0.0, 0.0], [5.0, 5.0, 5.0]);

# fi_j -> i-th function in j-th level

g(x) = (x[3]-5*(1-((x[1]-2)^2+(x[2]-2)^2)/(9+(x[1]-2)^2+(x[2]-2)^2)))^2
f1_1(x) = cos(pi*x[1]/10)*cos(pi*x[2]/10)
f2_1(x) = cos(pi*x[1]/10)*sin(pi*x[2]/10)
f3_1(x) = sin(pi*x[1]/10)+g(x)

f1_2(x) = ((x[1]-2)^2+(x[2]-2)^2-1)^2
f2_2(x) = ((x[1]-2)^2+(x[2]-2)^2-3)^2

function CostFunction(x)

	return [f1_1(x), f2_1(x), f3_1(x), f1_2(x), f2_2(x)]
end

function print_iter(P, gen::Int=0)
    println("[Iteration $gen: Number of solutions = $(length(P))]")
end

function build_levels!(EP)
	
	for ind in EP
		ind.y = [ind.y[1] ind.y[4];
				 ind.y[2] ind.y[5];
				 ind.y[3] 0]
	end

end

function PL_A(filename; show_front=false)

    MaxIt = 500;  # Maximum Number of Iterations
    nPop = 200;    # Population Size [Number of Sub-Problems]

    priorities = [3,2]

    EP = schmiedle(nPop, Min(), priorities, MaxIt, CostFunction, bc, fplot=print_iter, plotevery=1000, showprogress=false);
    
    if show_front
		X = map(x->x.y[1], EP)
		Y = map(x->x.y[2], EP)
		Z = map(x->x.y[3], EP)
		
		scatter3D(X, Y, Z, marker=:x);
	end

	build_levels!(EP)
	
	save_front(EP, filename);
   	
	nothing
end
