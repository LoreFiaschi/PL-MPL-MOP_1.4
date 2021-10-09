@everywhere include("utils/io.jl")
@everywhere include("utils/metrics.jl")

@everywhere using DataFrames, CSV, ProgressMeter, Statistics
@everywhere using .metrics

@everywhere include("../Utils/src/io_matrix.jl")

@everywhere function compute_performance(input)
	benchmark, levels_size, num_trials, alg_names, dataframe_col_names = input
	# Matrix for storing the performances of each trial and computing mean and std
	performance_matrix = Matrix{Ban}(undef, num_trials, length(alg_names))

	# Vectors for performances mean and std
	stds = Vector{Ban}(undef, length(alg_names))
	num_sol = zeros(length(alg_names))

	sources = [["outputs/$(alg_names[j])/$(benchmark)_$(i).bin" for j=1:length(alg_names)] for i=1:num_trials]

	destinations = ["performance/$(benchmark)/$(i).bin" for i=1:num_trials]

	for (i, (source, destination)) in enumerate(zip(sources, destinations))
		populations = [load_front(filename) for filename in source]
		for j in eachindex(populations)
			num_sol[j] += ((length(populations[j])-num_sol[j])/i) # incremental mean
		end
		performance = delta_metric(populations, levels_size, Min())

		# Update the performances matrix
		performance_matrix[i,:] = deepcopy(performance)
	end

	# Matrix for storing as csv the performances of each trial
	performance_matrix_standard = [(1:size(performance_matrix, 1)) map(x->standard_part(x), performance_matrix)]

	df = DataFrame(performance_matrix_standard)
	rename!(df, [Symbol(col_name) for col_name in dataframe_col_names])
	CSV.write("performance/$(benchmark)/performances.csv",  df)

	# Vectors for performance mean 
	means = mean(performance_matrix, dims=1)
	means = means[1,:]

	for i=1:length(alg_names)
		stds[i] = stdm(performance_matrix[:,i], means[i])
	end

	# Write algorithms performance in a file
	open("performance/$(benchmark)/statistics.bin", "w") do io
		write_matrix(io, [means stds])
	end

	# Write algorithms average number of solution in a file
	open("performance/$(benchmark)/num_solutions.bin", "w") do io
		write_matrix(io, num_sol)
	end
end

num_trials = 50
alg_names = ["PL-NSGA-II", "NSGA-II", "NSGA-III", "MOEAD", "SCHMIEDLE"]
dataframe_col_names = ["RUN","PLNSGAII", "NSGAII", "NSGA-III", "MOEAD", "SCHMIEDLE"]

benchmark = ["Crash", "MaF7", "MaF11"]
levels_size = [[2,2], [3,3], [3,2]]
#benchmark = ["Crash", "MaF7", "MaF11", "PL_C"]
#levels_size = [[2,2], [3,3], [3,2], [3,2,3]]
input = []

for (b, l) in zip(benchmark, levels_size)
	push!(input, [b, l, num_trials, alg_names, dataframe_col_names])
end

pmap(compute_performance, input)


#compute_performance(["PL_C", [3,2,3], num_trials, alg_names, dataframe_col_names])

nothing
