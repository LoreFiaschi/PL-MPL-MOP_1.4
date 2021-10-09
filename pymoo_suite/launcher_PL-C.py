from problems import PL_C
from pymoo.algorithms.moo.nsga3 import NSGA3
from pymoo.algorithms.moo.nsga2 import NSGA2
from pymoo.algorithms.moo.moead import MOEAD
from pymoo.factory import get_termination, get_reference_directions
from pymoo.optimize import minimize
from pymoo.decomposition.pbi import PBI
from utils import postfiltering, save_front
import numpy as np
from multiprocessing import Pool

def optimize_nsga3(i):
	problem = PL_C()

	ref_dirs = get_reference_directions("das-dennis", 8, n_partitions=4)
	algorithm = NSGA3(ref_dirs = ref_dirs,
		                pop_size = 330)

	termination = get_termination("n_gen", 500)

	res = minimize(problem,
		           algorithm,
		           termination,
		           save_history=False,
		           verbose=False)
		           
	PF = postfiltering(res.F, [[True, True, True, False, False, False, False, False],\
								[False, False, False, True, True, False, False, False],\
								[False, False, False, False, False, True, True, True]])

	PF = PF[:, [0,3,5,1,4,6,2,7]]

	save_front(PF, "../outputs/NSGA-III/PL_C_"+str(i+1)+".bin", [3,2,3])

def optimize_moead(i):

	problem = PL_C()

	ref_dirs = get_reference_directions("das-dennis", 8, n_partitions=4)
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

	PF = postfiltering(res.F, [[True, True, True, False, False, False, False, False],\
								[False, False, False, True, True, False, False, False],\
								[False, False, False, False, False, True, True, True]])

	PF = PF[:, [0,3,5,1,4,6,2,7]]

	save_front(PF, "../outputs/MOEAD/PL_C_"+str(i+1)+".bin", [3,2,3])
    
def optimize_nsga2(i):

	problem = PL_C()

	algorithm = NSGA2(pop_size = 200)

	termination = get_termination("n_gen", 500)

	res = minimize(problem,
		           algorithm,
		           termination,
		           save_history=False,
		           verbose=False)
		           
	PF = postfiltering(res.F, [[True, True, True, False, False, False, False, False],\
								[False, False, False, True, True, False, False, False],\
								[False, False, False, False, False, True, True, True]])

	PF = PF[:, [0,3,5,1,4,6,2,7]]

	save_front(PF, "../outputs/NSGA-II/PL_C_"+str(i+1)+".bin", [3,2,3])
            
if __name__ == '__main__':
    with Pool(8) as p:
        p.map(optimize_moead, range(50))

    with Pool(8) as p:
        p.map(optimize_nsga2, range(50))

    with Pool(8) as p:
        p.map(optimize_nsga3, range(50))
