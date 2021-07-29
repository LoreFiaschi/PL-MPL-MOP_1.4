from problems import MPL3_std
from pymoo.algorithms.nsga3 import NSGA3
from pymoo.algorithms.nsga2 import NSGA2
from pymoo.algorithms.moead import MOEAD
from pymoo.factory import get_termination, get_reference_directions
from pymoo.optimize import minimize
from utils import postfiltering
import numpy as np
from multiprocessing import Pool


f4 = lambda X : ((X[:,0]-2)**2+(X[:,1]-2)**2-1)**2
f5 = lambda X : ((X[:,0]-2)**2+(X[:,1]-2)**2-3)**2

def optimize_nsga3(i):
    problem = MPL3_std()

    ref_dirs = get_reference_directions("das-dennis", 3, n_partitions=12)
    algorithm = NSGA3(ref_dirs = ref_dirs,
                        pop_size = 100)

    termination = get_termination("n_gen", 500)

    res = minimize(problem,
                   algorithm,
                   termination,
                   save_history=False,
                   verbose=False)
                   
    F4 = f4(res.F)
    F5 = f5(res.F)

    num_ind = np.size(res.F, 0)

    with open("../outputs/NSGAIII/PL-A_pre_"+str(i+1)+".txt", "w") as file:
        file.write(str(num_ind)+"\n");
        file.write(str(2)+"\n");
        for j in range(0, num_ind):
            file.write(str(res.F[j,0])+";"+str(res.F[j,1])+";"+str(res.F[j,2])+"\n");
            file.write(str(F4[j])+";"+str(F5[j])+"\n");

def optimize_moead(i):

    problem = MPL3_std()

    ref_dirs = get_reference_directions("das-dennis", 3, n_partitions=12)
    algorithm = MOEAD(ref_dirs = ref_dirs,
                        n_neighbors = 15,
						decomposition="pbi",
						prob_neighbor_mating=0.7)

    termination = get_termination("n_gen", 500)
    
    res = minimize(problem,
                   algorithm,
                   termination,
                   save_history=False,
                   verbose=False)
                   
    F4 = f4(res.F)
    F5 = f5(res.F)
    
    num_ind = np.size(res.F, 0)

    with open("../outputs/MOEAD/PL-A_pre_"+str(i+1)+".txt", "w") as file:
        file.write(str(num_ind)+"\n");
        file.write(str(2)+"\n");
        for j in range(0, num_ind):
            file.write(str(res.F[j,0])+";"+str(res.F[j,1])+";"+str(res.F[j,2])+"\n");
            file.write(str(F4[j])+";"+str(F5[j])+"\n");
            
def optimize_nsga2(i):

    problem = MPL3_std()

    algorithm = NSGA2(pop_size = 100)

    termination = get_termination("n_gen", 500)

    res = minimize(problem,
                   algorithm,
                   termination,
                   save_history=False,
                   verbose=False)
                   
    F4 = f4(res.F)
    F5 = f5(res.F)

    num_ind = np.size(res.F, 0)

    with open("../outputs/NSGAII/PL-A_pre_"+str(i+1)+".txt", "w") as file:
        file.write(str(num_ind)+"\n");
        file.write(str(2)+"\n");
        for j in range(0, num_ind):
            file.write(str(res.F[j,0])+";"+str(res.F[j,1])+";"+str(res.F[j,2])+"\n");
            file.write(str(F4[j])+";"+str(F5[j])+"\n");



if __name__ == '__main__':
    with Pool(8) as p:
        p.map(optimize_moead, range(50))

    with Pool(8) as p:
        p.map(optimize_nsga2, range(50))

    with Pool(8) as p:
        p.map(optimize_nsga3, range(50))
