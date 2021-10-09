using LinearAlgebra
using PyPlot

g1(x) = 10 * (exp(-x / (1 + exp(-x)))) * (0.3 + cos(2*x)^2)

xrange = 0:0.01:10
points = [[x, g1(x)] for x in xrange]
x_coords = map(p -> p[1], points)
y_coords = map(p -> p[2], points)

x_opt = Vector{Float64}()
y_opt = Vector{Float64}()
min_el = 100

for i in 1:size(points)[1]
    if y_coords[i] < min_el
        min_el = y_coords[i]
        push!(x_opt, x_coords[i])
        push!(y_opt, y_coords[i])
    end
end

##############

pyplot(xticks = 0:0.2:3, yticks=-1:0.5:1, zticks=0.3:0.3:0.9, xlabel="$\|x\|$", ylabel="g(x)")
PyPlot.plot(x_coords, y_coords, color="red")
PyPlot.scatter(x_opt, y_opt, color="green");
