include("../src/schmiedle.jl")

using .SCHMIEDLE
using PyPlot
using LinearAlgebra

const bc = BinaryCoding(5, [0.0, 0.0], [10.0, 10.0]);

# fi_j -> i-th function in j-th level

d(x,y) = norm(x-y)

f1_1(x) = x[1]
f2_1(x) = x[2]

f1_3(x) = d(x, [ 5.0,  5.0]) #d(x, [ 4.0,  4.0]) #
f2_3(x) = d(x, [10.0,  6.0])
f3_3(x) = d(x, [ 6.0, 10.0])


function CostFunction(x)

	r = sqrt(x[1]^2+x[2]^2);
	
	f3_1 = 10*(exp(-r) / (1 + exp(-r))) * (0.3 + cos(2*r)^2)
	f1_2 = cos(2*r)
	f2_2 = -sin(2*r)

    return [f1_1(x), f2_1(x), f3_1, f1_2, f2_2, f1_3(x), f2_3(x), f3_3(x)]
end

function print_iter(P, gen::Int=0)
    println("[Iteration $gen: Number of solutions = $(length(P))]")
end

function PL_C(filename)
    
    MaxIt = 500;  # Maximum Number of Iterations
    nPop = 100;    # Population Size [Number of Sub-Problems]
	
	priorities = [3, 2, 3]

    EP = schmiedle(nPop, Min(), priorities, MaxIt, CostFunction, bc, fplot=print_iter, plotevery=1000, showprogress=false);

	X = map(x->x.y[1], EP)
    Y = map(x->x.y[2], EP)
    Z = map(x->x.y[3], EP)
    
    scatter3D(X, Y, Z, marker=:x);

	nothing
end
