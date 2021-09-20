include("../src/NSGAII.jl")

using .PLNSGAII
using PyPlot
using DataFrames, CSV

const bc = BinaryCoding(5, [1.0, 1.0, 1.0, 1.0, 1.0], [3.0, 3.0, 3.0, 3.0, 3.0]);

# fi_j -> i-th function in j-th level

f1_1(x) = 1640.2823 + 2.3573285*x[1] + 2.3220035*x[2] +
		  4.5688768*x[3] + 7.7213633*x[4] + 4.4559504*x[5];
f2_1(x) = 6.5856 + 1.15*x[1] - 1.0427*x[2] + 0.9738*x[3] + 
          0.8364*x[4] - 0.3695*x[1]*x[4] + 0.0861*x[1]*x[5] +
		  0.3628*x[2]*x[4] - 0.1106*x[1]*x[1] - 0.3437*x[3]*x[3] +
		  0.1764*x[4]*x[4];

f1_2(x) = f2_1(x)
f2_2(x) = -0.0551 + 0.0181*x[1] + 0.1024*x[2] + 0.0421*x[3] -
          0.0073*x[1]*x[2] + 0.024*x[2]*x[3] - 0.0118*x[2]*x[4] -
		  0.0204*x[3]*x[4] - 0.008*x[3]*x[5] - 0.0241*x[2]*x[2] +
		  0.0109*x[4]*x[4];


function CostFunction(x)

	return [f1_1(x) f1_2(x);
			f2_1(x) f2_2(x)] 

end

function print_iter(P, gen::Int=0)
    println("[Iteration $gen: Number of solutions = $(length(P))]")
end

function Crash(filename; show_front=false)

    MaxIt = 600;  # Maximum Number of Iterations
    nPop = 200;    # Population Size [Number of Sub-Problems]

    EP = nsga(nPop, MaxIt, CostFunction, bc, fplot=print_iter, plotevery=1000, showprogress = true);
    
    X = map(x->x.y[1], EP) # equivalent to x.y[1,1]
    Y = map(x->x.y[2], EP)
    
    scatter(X, Y, marker=:x);

	xlabel(L"f^{(1)}_1");
	ylabel(L"f^{(1)}_2");
	
#	df = DataFrame([map(x->x.y[1][0], EP) map(x->x.y[2][0], EP) map(x->x.y[2][-1], EP)])
#	CSV.write(filename, df)

	nothing
	
end
