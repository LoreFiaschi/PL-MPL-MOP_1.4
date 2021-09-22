include("../src/NSGAII.jl")
include("../../utils/io.jl")

using .PLNSGAII
using PyPlot

const bc = BinaryCoding(5, [0.0, 0.0, 0.0], [1.0, 1.0, 1.0]);

alpha = 2.5
beta = 10

# fi_j -> i-th function in j-th level

g(x) = beta*(x[3]-x[1])^2

f1_1(x) = (1-x[1]*x[2])*(1+g(x))
f2_1(x) = (1-x[1]*(1-x[2]))*(1+g(x))
f3_1(x) = x[1]*(1+g(x))

f1_2(x) = cospi(x[1]/2)*cospi(x[2]/2)+beta*(x[1]^(alpha*x[3])-x[2])^2
f2_2(x) = cospi(x[1]/2)*sinpi(x[2]/2)+beta*(x[1]^(alpha*x[3])-x[2])^2
f3_2(x) = sinpi(x[1]/2)+beta*(x[1]^(alpha*x[3])-x[2])^2

f1_3(x) = cospi((x[1]+x[3]-1)/2)
f2_3(x) = cospi(2*(x[1]+x[3]))
f3_3(x) = 1/(1+0.3*(x[1]+x[3]-1)^2)-2/(1+1750*(x[1]+x[3]-1)^2)

function CostFunction(x)

	return [f1_1(x) f1_2(x) f1_3(x);
			f2_1(x) f2_3(x) f2_3(x);
			f3_1(x) f3_2(x) f3_3(x)]
end

function print_iter(P, gen::Int=0)
    println("[Iteration $gen: Number of solutions = $(length(P))]")
end

function PL_B(filename; show_front=false)

    MaxIt = 500;  # Maximum Number of Iterations
    nPop = 200;    # Population Size [Number of Sub-Problems]

    EP = nsga(nPop, MaxIt, CostFunction, bc, fplot=print_iter, plotevery=1000, showprogress = false);
    
    if show_front
		X = map(x->x.y[1], EP) # equivalent to x.y[1,1]
		Y = map(x->x.y[2], EP)
		Z = map(x->x.y[3], EP)
		
		scatter3D(X, Y, Z, marker=:x);
	end
	
	save_front(EP, filename);

	nothing
end
