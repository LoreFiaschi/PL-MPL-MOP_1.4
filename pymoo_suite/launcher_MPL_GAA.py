from problems import MPL_GAA
from pymoo.algorithms.nsga3 import NSGA3
from pymoo.algorithms.nsga2 import NSGA2
from pymoo.algorithms.moead import MOEAD
from pymoo.factory import get_termination, get_reference_directions
from pymoo.optimize import minimize
from utils import postfiltering
import numpy as np
from multiprocessing import Pool

def optimize_nsga3(i):
	problem = MPL_GAA()

	ref_dirs = get_reference_directions("das-dennis", 10, n_partitions=3)
	algorithm = NSGA3(ref_dirs = ref_dirs,
		                pop_size = 250)

	termination = get_termination("n_gen", 2000)

	res = minimize(problem,
		           algorithm,
		           termination,
		           save_history=False,
		           verbose=False)
		           
	PF = postfiltering(res.F, [[False,False,False,False,False,False,False,False,False,True], \
		                       [False,False,True,False,False,False,True,True,False,False], \
		                       [True,True,False,False,False,True,False,False,False,False], \
		                       [False,False,False,True,True,False,False,False,True,False]])

	num_ind = np.size(PF, 0)

	with open("../outputs/NSGAIII/MPL_GAA_"+str(i+1)+".txt", "w") as file:
		file.write(str(num_ind)+"\n");
		file.write(str(4)+"\n");
		for j in range(0, num_ind):
			file.write(str(PF[j,9])+"\n")
			file.write(str(PF[j,2])+";"+str(PF[j,7])+";"+str(PF[j,6])+"\n");
			file.write(str(PF[j,0])+";"+str(PF[j,5])+";"+str(PF[j,1])+"\n");
			file.write(str(PF[j,3])+";"+str(PF[j,4])+";"+str(PF[j,8])+"\n");

def optimize_moead(i):

	problem = MPL_GAA()

	ref_dirs = get_reference_directions("das-dennis", 10, n_partitions=3)
	algorithm = MOEAD(ref_dirs = ref_dirs,
		                n_neighbors = 15,
						decomposition="pbi",
						prob_neighbor_mating=0.7)

	termination = get_termination("n_gen", 2000)

	res = minimize(problem,
		           algorithm,
		           termination,
		           save_history=False,
		           verbose=False)

#	print(np.shape(res.F))
	PF = postfiltering(res.F, [[False,False,False,False,False,False,False,False,False,True], \
		                       [False,False,True,False,False,False,True,True,False,False], \
		                       [True,True,False,False,False,True,False,False,False,False], \
		                       [False,False,False,True,True,False,False,False,True,False]])

	num_ind = np.size(PF, 0)

	with open("../outputs/MOEAD/MPL_GAA_"+str(i+1)+".txt", "w") as file:
		file.write(str(num_ind)+"\n");
		file.write(str(4)+"\n");
		for j in range(0, num_ind):
			file.write(str(PF[j,9])+"\n")
			file.write(str(PF[j,2])+";"+str(PF[j,7])+";"+str(PF[j,6])+"\n");
			file.write(str(PF[j,0])+";"+str(PF[j,5])+";"+str(PF[j,1])+"\n");
			file.write(str(PF[j,3])+";"+str(PF[j,4])+";"+str(PF[j,8])+"\n");
		    
def optimize_nsga2(i):

	problem = MPL_GAA()

	algorithm = NSGA2(pop_size = 200)

	termination = get_termination("n_gen", 2000)

	res = minimize(problem,
		           algorithm,
		           termination,
		           save_history=False,
		           verbose=False)
		           
	PF = postfiltering(res.F, [[False,False,False,False,False,False,False,False,False,True], \
		                       [False,False,True,False,False,False,True,True,False,False], \
		                       [True,True,False,False,False,True,False,False,False,False], \
		                       [False,False,False,True,True,False,False,False,True,False]])

	num_ind = np.size(PF, 0)

	with open("../outputs/NSGAII/MPL_GAA_"+str(i+1)+".txt", "w") as file:
		file.write(str(num_ind)+"\n");
		file.write(str(4)+"\n");
		for j in range(0, num_ind):
			file.write(str(PF[j,9])+"\n")
			file.write(str(PF[j,2])+";"+str(PF[j,7])+";"+str(PF[j,6])+"\n");
			file.write(str(PF[j,0])+";"+str(PF[j,5])+";"+str(PF[j,1])+"\n");
			file.write(str(PF[j,3])+";"+str(PF[j,4])+";"+str(PF[j,8])+"\n");

if __name__ == '__main__':
    #with Pool(8) as p:
    #    p.map(optimize_moead, range(50))
	
    with Pool(8) as p:
        p.map(optimize_nsga2, range(50))

    with Pool(8) as p:
        p.map(optimize_nsga3, range(50))
