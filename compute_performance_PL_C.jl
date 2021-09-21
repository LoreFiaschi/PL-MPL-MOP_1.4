include("utils/io.jl")
include("utils/delta_metric.jl")
include("../utils/io_matrix.jl")
include("../ArithmeticNonStandarNumbersLibrary/src/BAN.jl")

using DataFrames, CSV, ProgressMeter, Statistics
using .BAN

num_trials = 50

alg_names = ["PL-NSGA-II", "DEB-NSGA-II", "NSGA-II", "MOEAD", "SCHMIEDLE"]
dataframe_col_names = ["RUN","PLNSGAII", "DEBNSGAII", "NSGAII", "MOEAD", "SCHMIEDLE"]
benchmark = "PL_C"
minimize = true

# Matrix for storing the performances of each trial and computing mean and std
performance_matrix = Matrix{BAN}(undef, num_it, length(alg_names))

# Vectors for performances mean and std
stds = Vector{Ban}(undef, length(alg_names))

sources = [["outputs/$(alg_names[j])/$(benchmark)_$(i).bin" for j=1:length(alg_names)] for i=1:num_trials]

destinations = ["performance/$(benchmark)/$(i).bin" for i=1:num_trials]

for (i, (source, destination)) in enumerate(zip(sources, destinations))
	performance = delta_metric(source, minimize)
	
	# Write algorithms performance in a file
	open(destination, "w") do io
		write_matrix(io, performance)
	end

	# Update the performances matrix
    performance_matrix[i,:] = deepcopy(performance)
end

# Matrix for storing as csv the performances of each trial
performance_matrix_standard = [(1:size(performance_matrix, 1)) map(x->standard_part(x), performance_matrix)]

df = DataFrame(performance_matrix_standard)
names!(df, [Symbol(col_name) for col_name in dataframe_col_names])
CSV.write("performance/$(benchmark)/performances.csv",  df)

# Vectors for performance mean 
means = mean(performance_matrix, dims=2)

for i=1:length(alg_names)
	stds[i] = stdm(performance_matrix[:,i], means[i])
end

# Write algorithms performance in a file
open("performance/$(benchmark)/statistics.bin", "w") do io
	write_matrix(io, [means stds])
end

nothing