from problems import PL_A_std
from pymoo.algorithms.moo.nsga3 import NSGA3
from pymoo.algorithms.moo.nsga2 import NSGA2
from pymoo.algorithms.moo.moead import MOEAD
from pymoo.factory import get_termination, get_reference_directions
from pymoo.optimize import minimize
from pymoo.decomposition.pbi import PBI
from utils import save_front
import numpy as np
from multiprocessing import Pool


f4 = lambda X : ((X[:,0]-2)**2+(X[:,1]-2)**2-1)**2
f5 = lambda X : ((X[:,0]-2)**2+(X[:,1]-2)**2-3)**2

def optimize_nsga3(i):
    problem = PL_A_std()

    ref_dirs = get_reference_directions("das-dennis", 3, n_partitions=12)
    algorithm = NSGA3(ref_dirs = ref_dirs,
                        pop_size = 100)

    termination = get_termination("n_gen", 500)

    res = minimize(problem,
                   algorithm,
                   termination,
                   save_history=False,
                   verbose=False)
                   
    F4 = f4(res.X)
    F5 = f5(res.X)

	PF = np.column_stack([res.F, F4, F5])

	save_front(PF, "../outputs/NSGA-III/PL_A_pre_"+str(i+1)+".bin", [3,2])

def optimize_moead(i):

    problem = PL_A_std()

    ref_dirs = get_reference_directions("das-dennis", 3, n_partitions=12)
    algorithm = MOEAD(ref_dirs = ref_dirs,
                        n_neighbors = 15,
						decomposition=PBI(),
						prob_neighbor_mating=0.7)

    termination = get_termination("n_gen", 500)
    
    res = minimize(problem,
                   algorithm,
                   termination,
                   save_history=False,
                   verbose=False)
                   
    F4 = f4(res.X)
    F5 = f5(res.X)
    
	PF = np.column_stack([res.F, F4, F5])

	save_front(PF, "../outputs/MOEAD/PL_A_pre_"+str(i+1)+".bin", [3,2])
            
def optimize_nsga2(i):

    problem = PL_A_std()

    algorithm = NSGA2(pop_size = 100)

    termination = get_termination("n_gen", 500)

    res = minimize(problem,
                   algorithm,
                   termination,
                   save_history=False,
                   verbose=False)
                   
    F4 = f4(res.X)
    F5 = f5(res.X)

	PF = np.column_stack([res.F, F4, F5])

	save_front(PF, "../outputs/NSGA-II/PL_A_pre_"+str(i+1)+".bin", [3,2])



if __name__ == '__main__':
    with Pool(8) as p:
        p.map(optimize_moead, range(50))

    with Pool(8) as p:
        p.map(optimize_nsga2, range(50))

    with Pool(8) as p:
        p.map(optimize_nsga3, range(50))
