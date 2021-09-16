include("../src/NSGAII.jl")

using .PLNSGAII
using LinearAlgebra
using PyPlot

const bc = BinaryCoding(10, [0.0, 0.0], [10.0, 10.0]);

r(x) = sqrt(x[1]^2+x[2]^2)
g(x) = 10*(exp(-(r(x))) / (1 + exp(-(r(x))))) * (0.3 + cos(2 * r(x))^2)
d(x,y) = norm(x-y)

f1_1(x) = x[1]
f2_1(x) = x[2]
f3_1(x) = g(x)

f1_2(x) = cos(2*r(x))
f2_2(x) = -sin(2*r(x))
f3_2(x) = 0

f1_3(x) = d(x, [ 4.0,  4.0]) #d(x, [ 5.0,  5.0])
f2_3(x) = d(x, [10.0,  6.0])
f3_3(x) = d(x, [ 6.0, 10.0])

function CostFunction(x)
    return [f1_1(x) f1_2(x) f1_3(x);
        	f2_1(x) f2_2(x) f2_3(x);
        	f3_1(x) f3_2(x) f3_3(x)]
end

function print_iter(P, gen::Int=0)
    println("[Iteration $gen: Number of solutions = $(length(P))]")
end

function MPL5(filename)

    MaxIt = 500;  # Maximum Number of Iterations
    nPop = 100;    # Population Size [Number of Sub-Problems]

    EP = nsga(nPop, MaxIt, CostFunction, bc, fplot=print_iter, plotevery=1000, showprogress = true);
    
    X = map(x->x.y[1], EP)
    Y = map(x->x.y[2], EP)
    Z = map(x->x.y[3], EP)
    
    figure(4)
    clf();
    scatter3D(X, Y, Z, marker=:x);

end
