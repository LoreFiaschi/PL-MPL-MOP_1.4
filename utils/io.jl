function save_front(pop, filename::String)
	open(filename, "w") do io
		write(io, length(pop))
		r = size(pop[1].y, 1)
		c = size(pop[1].y, 2)
		write(io, r)
		write(io, c)
		for ind in pop
			for i=1:r
				for j=1:c
					write(io, ind.y[i,j])
				end
			end
		end
	end
	nothing
end

function load_front(filename::String, T1::Type=Int64, T2::Type=Float64)
	pop = []
	open(filename, "r") do io
		pop_size = read(io, T1)
		r = read(io, T1)
		c = read(io, T1)
		pop = Vector{Matrix{T2}}(undef, pop_size)
		M = Matrix{T2}(undef, r, c)
		for p=1:pop_size
			for i=1:r
				for j=1:c
					M[i,j] = read(io, T2)
				end
			end
			pop[p] = deepcopy(M)
		end
	end
	return pop
end
