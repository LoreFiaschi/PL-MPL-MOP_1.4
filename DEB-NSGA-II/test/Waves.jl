include("../src/NSGAII.jl")

using .DEB_PLNSGAII
using PyPlot

const bc = BinaryCoding(5, [0.0, 0.0], [2*pi, 2*pi]);

# fi_j -> i-th function in j-th level

f1_1(x) = sin(x[1])*sin(x[2]);
f2_1(x) = cos(x[1])*cos(x[2]);

f1_2(x) = (v=f1_1(x); w=f2_1(x); -(v^2+w^2-2*v*w-1.4*v+1.4*w+0.48);)
f2_2(x) = (v=f1_1(x); w=f2_1(x); -(v^2+w^2-2*v*w+1.4*v-1.4*w+0.48);)

function CostFunction(x)

	return [f1_1(x) f1_2(x); f2_1(x) f2_2(x)]
end

function print_iter(P, gen::Int=0)
    println("[Iteration $gen: Number of solutions = $(length(P))]")
end

function Waves(filename)

    MaxIt = 600;  # Maximum Number of Iterations
    nPop = 100;    # Population Size [Number of Sub-Problems]

    EP = nsga(nPop, MaxIt, CostFunction, bc, fplot=print_iter, plotevery=1000, showprogress = true);
    
    X = map(x->x.y[1], EP) # equivalent to x.y[1,1]
    Y = map(x->x.y[2], EP)
    
    scatter(X, Y, marker=:x);
	xlabel(L"f^{(1)}_1");
	ylabel(L"f^{(1)}_2");
	
	nothing
end
