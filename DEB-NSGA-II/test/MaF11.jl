include("../src/NSGAII.jl")

using .DEB_PLNSGAII
using PyPlot

const bc = BinaryCoding(5, zeros(12), [2*i for i=1:12]);

# fi_j -> i-th function in j-th level

z(i,x) = x[i]/(2i)
t1(i,x) = (i<=2) ? z(i,x) : abs(z(i,x)-0.35)/(abs(0.35-z(i,x))+0.35)
t2(i,x) = (i<=2) ? t1(i,x) : t1(2+2*(i-2)-1,x) + t1(2+2*(i-2),x) + 2*abs(t1(2+2*(i-2)-1,x)-t1(2+2*(i-2),x))
t3(i,x) = (i<=2) ? t2(i,x) : sum([t2(j,x) for j=3:6])/5
y(i,x) = (i<=2) ? (t3(i,x)-0.5)*max(1,t3(3,x))+0.5 : t3(3,x)

function CostFunction(x)
	
	y1 = y(1,x)
	y2 = y(2,x)
	y3 = y(3,x)
	v = y3 + 2*(1-cospi(y1/2))*(1-cospi(y2/2))
	w = y3 + 4*(1-cospi(y1/2))*(1-sinpi(y2/2))
	
	# a = 4(w + (1/0.45 -2)v)
	# b = 4(-v+2w)
    
    f1_1  =    v
    f1_2 =    -(w-2v-2.75)^2-0.125 # -(w-2v+3)*(w-2v+2.5) 
	
    f2_1  =    w
    f2_2 =    -(w-2v+2.75)^2-0.125 # -(w-2v-2)*(w-2v-1.5) 
	
	f3_1 =     y3 + 6*(1-y1*cospi(5*y1)^2)

    return [f1_1 f1_2;
			f2_1 f2_2;
			f3_1 0]
end


function print_iter(P, gen::Int=0)
    println("[Iteration $gen: Number of solutions = $(length(P))]")
end

function MaF11(filename)

    MaxIt = 2500;  # Maximum Number of Iterations
    nPop = 200;    # Population Size [Number of Sub-Problems]

    EP = nsga(nPop, MaxIt, CostFunction, bc, fplot=print_iter, plotevery=1000, showprogress = true);
    
	X = map(x->x.y[1], EP) # equivalent to x.y[1,1]
    Y = map(x->x.y[2], EP)
    Z = map(x->x.y[3], EP)
    
    scatter3D(X, Y, Z, marker=:x);
	xlabel(L"f^{(1)}_1");
	ylabel(L"f^{(1)}_2");
	zlabel(L"f^{(1)}_3");
	
	xlim((0, 2))
	ylim((0, 4))
	zlim((0, 6))

	nothing
end
