include("../io.jl")

struct ind
	y::Matrix{Float64}
end

function test_io()
	pop_size = 2
	r = 3
	c = 4
	filename = "io_matrices.bin" #"io_matrices.txt" #

	pop = Vector{ind}(undef,pop_size)

	for i=1:pop_size
		pop[i] = ind(rand(r,c))
		show(pop[i].y)
		println("")
		println("")
	end

	println("")

	save_front(pop, filename)

	new_pop = load_front(filename)

	for m in new_pop
		show(m)
		println("")
		println("")
	end
	nothing
end

test_io()
