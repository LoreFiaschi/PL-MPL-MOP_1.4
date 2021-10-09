include("../src/NSGAII.jl")
include("../../utils/io.jl")

using .PLNSGAII
using LinearAlgebra
using DataFrames, CSV

const bc = BinaryCoding(10, [0.0, 0.0], [10.0, 10.0]);

# fi_j -> i-th function in j-th level

d(x,y) = norm(x-y)

f1_1(x) = x[1]
f2_1(x) = x[2]

f1_3(x) = d(x, [ 5.0,  5.0]) #d(x, [ 4.0,  4.0]) #
f2_3(x) = d(x, [10.0,  6.0])
f3_3(x) = d(x, [ 6.0, 10.0])

function CostFunction1(x)

	r = sqrt(x[1]^2+x[2]^2);
	
	f3_1 = 10*(exp(-r) / (1 + exp(-r))) * (0.3 + cos(2*r)^2)
	
    return [f1_1(x);
        	f2_1(x);
        	f3_1   ]
end


function CostFunction2(x)

	r = sqrt(x[1]^2+x[2]^2);
	
	f3_1 = 10*(exp(-r) / (1 + exp(-r))) * (0.3 + cos(2*r)^2)
	f1_2 = cos(2*r)
	f2_2 = -sin(2*r)
	
    return [f1_1(x) f1_2;
        	f2_1(x) f2_2;
        	f3_1    0   ]
end


function CostFunction3(x)

	r = sqrt(x[1]^2+x[2]^2);
	
	f3_1 = 10*(exp(-r) / (1 + exp(-r))) * (0.3 + cos(2*r)^2)
	f1_2 = cos(2*r)
	f2_2 = -sin(2*r)
	
    return [f1_1(x) f1_2 f1_3(x);
        	f2_1(x) f2_2 f2_3(x);
        	f3_1    0    f3_3(x)]
end

function print_iter(P, gen::Int=0)
    println("[Iteration $gen: Number of solutions = $(length(P))]")
end


MaxIt = 1000;  # Maximum Number of Iterations
nPop = 500;    # Population Size [Number of Sub-Problems]

EP = nsga(nPop, MaxIt, CostFunction1, bc, fplot=print_iter, plotevery=1001, showprogress = true);
S = map(x->x.y[:,1], EP)
df = DataFrame(hcat(S...)')
CSV.write("fronts/PL_C_1.csv",  df, header=false)

EP = nsga(nPop, MaxIt, CostFunction2, bc, fplot=print_iter, plotevery=1001, showprogress = true);
S = map(x->x.y[:,1], EP)
df = DataFrame(hcat(S...)')
CSV.write("fronts/PL_C_2.csv",  df, header=false)

EP = nsga(nPop, MaxIt, CostFunction3, bc, fplot=print_iter, plotevery=1001, showprogress = true);
S = map(x->x.y[:,1], EP)
df = DataFrame(hcat(S...)')
CSV.write("fronts/PL_C_3.csv",  df, header=false)

nothing
