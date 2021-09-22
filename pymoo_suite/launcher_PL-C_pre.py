from problems import MPL5_std
from pymoo.algorithms.nsga3 import NSGA3
from pymoo.algorithms.nsga2 import NSGA2
from pymoo.algorithms.moead import MOEAD
from pymoo.factory import get_termination, get_reference_directions
from pymoo.optimize import minimize
from utils import save_front
import numpy as np
from multiprocessing import Pool
from math import pi


r  = lambda X : np.sqrt(X[:,0]**2+X[:,1]**2)

f4 = lambda X : np.cos(2*r(X))
f5 = lambda X : -np.sin(2*r(X))

f6 = lambda X : numpy.linalg.norm(X-(np.ones((np.size(X, axis=0), n_var))*4), axis=1)
f7 = lambda X : numpy.linalg.norm(X-(np.ones((np.size(X, axis=0), n_var))*[10, 6]), axis=1)
f8 = lambda X : numpy.linalg.norm(X-(np.ones((np.size(X, axis=0), n_var))*[6, 10]), axis=1)

def optimize_nsga3(i):
    problem = MPL5_std()

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
    F6 = f6(res.F)
    F7 = f7(res.F)
    F8 = f8(res.F)

    PF = np.hstack([res.F, F4, F5, F6, F7, F8])

	save_front(PF, "../outputs/NSGA-III/PL_C_pre_"+str(i+1)+".bin", [3,2,3])

    

def optimize_moead(i):

    problem = MPL5_std()

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
    F6 = f6(res.F)
    F7 = f7(res.F)
    F8 = f8(res.F)
    
    PF = np.hstack([res.F, F4, F5, F6, F7, F8, F9])

	save_front(PF, "../outputs/MOEAD/PL_C_pre_"+str(i+1)+".bin", [3,2,3])
            
def optimize_nsga2(i):

    problem = MPL5_std()

    algorithm = NSGA2(pop_size = 100)

    termination = get_termination("n_gen", 500)

    res = minimize(problem,
                   algorithm,
                   termination,
                   save_history=False,
                   verbose=False)
                   
    F4 = f4(res.F)
    F5 = f5(res.F)
    F6 = f6(res.F)
    F7 = f7(res.F)
    F8 = f8(res.F)

    PF = np.hstack([res.F, F4, F5, F6, F7, F8, F9])

	save_front(PF, "../outputs/NSGA-II/PL_C_pre_"+str(i+1)+".bin", [3,2,3])



if __name__ == '__main__':
    with Pool(8) as p:
        p.map(optimize_moead, range(50))

    with Pool(8) as p:
        p.map(optimize_nsga2, range(50))

    with Pool(8) as p:
        p.map(optimize_nsga3, range(50))
