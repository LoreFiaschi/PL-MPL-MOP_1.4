from problems import MPL4
from pymoo.algorithms.nsga3 import NSGA3
from pymoo.algorithms.nsga2 import NSGA2
from pymoo.algorithms.moead import MOEAD
from pymoo.factory import get_termination, get_reference_directions
from pymoo.optimize import minimize
from utils import postfiltering, save_front
import numpy as np
from multiprocessing import Pool

def optimize_nsga3(i):
    problem = MPL4()

    ref_dirs = get_reference_directions("das-dennis", 9, n_partitions=3)
    algorithm = NSGA3(ref_dirs = ref_dirs,
                        pop_size = 180)

    termination = get_termination("n_gen", 500)

    res = minimize(problem,
                   algorithm,
                   termination,
                   save_history=False,
                   verbose=False)
                   
    PF = postfiltering(res.F, [[True, True, True, False, False, False, False, False, False],\
								[False, False, False, True, True, True, False, False, False],\
								[False, False, False, False, False, False, True, True, True]])

   	save_front(PF, "../outputs/NSGA-III/PL-B_"+str(i+1)+".bin", [3,3,3])

def optimize_moead(i):

    problem = MPL4()

    ref_dirs = get_reference_directions("das-dennis", 9, n_partitions=3)
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
                   
    PF = postfiltering(res.F, [[True, True, True, False, False, False, False, False, False],\
								[False, False, False, True, True, True, False, False, False],\
								[False, False, False, False, False, False, True, True, True]])
    
   	save_front(PF, "../outputs/MOEAD/PL-B_"+str(i+1)+".bin", [3,3,3])
            
def optimize_nsga2(i):

    problem = MPL4()

    algorithm = NSGA2(pop_size = 100)

    termination = get_termination("n_gen", 500)

    res = minimize(problem,
                   algorithm,
                   termination,
                   save_history=False,
                   verbose=False)
                   
    PF = postfiltering(res.F, [[True, True, True, False, False, False, False, False, False],\
								[False, False, False, True, True, True, False, False, False],\
								[False, False, False, False, False, False, True, True, True]])

   	save_front(PF, "../outputs/NSGA-II/PL-B_"+str(i+1)+".bin", [3,3,3])


if __name__ == '__main__':
    with Pool(8) as p:
        p.map(optimize_moead, range(50))

    with Pool(8) as p:
        p.map(optimize_nsga2, range(50))

    with Pool(8) as p:
        p.map(optimize_nsga3, range(50))
