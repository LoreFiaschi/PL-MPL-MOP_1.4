include("utils/io.jl")
include("utils/metrics.jl")

using DataFrames, CSV, ProgressMeter, Statistics
using .metrics

include("../Utils/src/io_matrix.jl")

function compute_performance(benchmark, levels_size, num_trials, alg_names, dataframe_col_names)
	# Matrix for storing the performances of each trial and computing mean and std
	performance_matrix = Matrix{Ban}(undef, num_trials, length(alg_names))

	# Vectors for performances mean and std
	stds = Vector{Ban}(undef, length(alg_names))

	sources = [["outputs/$(alg_names[j])/$(benchmark)_$(i).bin" for j=1:length(alg_names)] for i=1:num_trials]

	destinations = ["performance/$(benchmark)/$(i).bin" for i=1:num_trials]

	for (i, (source, destination)) in enumerate(zip(sources, destinations))
		populations = [load_front(filename) for filename in source]
		#check_nan(populations)
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
end

num_trials = 4
benchmark = ["Crash", "MaF7", "MaF11", "PL_C"]
levels_size = [[2,2], [3,3], [3,2], [3,2,3]]
alg_names = ["PL-NSGA-II", "DEB-NSGA-II", "NSGA-II", "NSGA-III", "MOEAD", "SCHMIEDLE"]
dataframe_col_names = ["RUN","PLNSGAII", "DEBNSGAII", "NSGAII", "NSGA-III", "MOEAD", "SCHMIEDLE"]

for (b, l) in zip(benchmark, levels_size)
	compute_performance(b, l, num_trials, alg_names, dataframe_col_names)
end

nothing
