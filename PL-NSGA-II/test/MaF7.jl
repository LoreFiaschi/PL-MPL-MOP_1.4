include("../src/NSGAII.jl")
include("../../utils/io.jl")

using .PLNSGAII
using PyPlot

const bc = BinaryCoding(5, [0.0, 0.0, 0.0], [1.0, 1.0, 20.0]);

# fi_j -> i-th function in j-th level

m=3;
k=20;
g(x) = 1+9/k*x[3];
h(x) = m*(1+g(x))-x[1]*(1+sinpi(3*x[1]))-x[2]*(1+sinpi(3*x[2]));

# Single petal
f1_1(x) = x[1];
f2_1(x) = x[2];
f3_1(x) = h(x);

f1_2(x) = -exp(-0.5*((x[1]-0.6)^2+(x[2]-0.6)^2));
f2_2(x) = abs((x[1]-0.8)^2+(x[2]-0.8)^2-0.2^2) # 
f3_2(x) = f3_1(x);


function CostFunction(x)

	return [f1_1(x) f1_2(x);
			f2_1(x) f2_2(x);
			f3_1(x) f3_2(x)]
end

function print_iter(P, gen::Int=0)
    println("[Iteration $gen: Number of solutions = $(length(P))]")
end

function MaF7(filename; show_front=false)

    MaxIt = 600;  # Maximum Number of Iterations
    nPop = 200;    # Population Size [Number of Sub-Problems]

    EP = nsga(nPop, MaxIt, CostFunction, bc, fplot=print_iter, plotevery=1000, showprogress = true);
    
	if show_front
		X = map(x->x.y[1], EP) # equivalent to x.y[1,1]
		Y = map(x->x.y[2], EP)
		Z = map(x->x.y[3], EP)
		
		scatter3D(X, Y, Z, marker=:x);
	end
	
	save_front(EP, filename);

	nothing
end
