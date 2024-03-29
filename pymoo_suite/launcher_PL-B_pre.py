from problems import PL_B_std
from pymoo.algorithms.moo.nsga3 import NSGA3
from pymoo.algorithms.moo.nsga2 import NSGA2
from pymoo.algorithms.moo.moead import MOEAD
from pymoo.factory import get_termination, get_reference_directions
from pymoo.optimize import minimize
from pymoo.decomposition.pbi import PBI
from utils import save_front
import numpy as np
from multiprocessing import Pool
from math import pi

alpha = 2.5
beta = 10

f4 = lambda X : np.cos(pi*X[:,0]/2)*np.cos(pi*X[:,1]/2)+beta*(X[:,0]**(alpha*X[:,2])-X[:,1])**2
f5 = lambda X : np.cos(pi*X[:,0]/2)*np.sin(pi*X[:,1]/2)+beta*(X[:,0]**(alpha*X[:,2])-X[:,1])**2
f6 = lambda X : np.sin(pi*X[:,0]/2)+beta*(X[:,0]**(alpha*X[:,2])-X[:,1])**2

f7 = lambda X : np.cos(pi/3*(X[:,0]+X[:,2]-1))
f8 = lambda X : np.cos(pi*4/3*(X[:,0]+X[:,2]))
f9 = lambda X : 1/(1+0.3*(X[:,0]+X[:,2]-1)**2)-2/(1+1750*(X[:,0]+X[:,2]-1)**2)

def optimize_nsga3(i):
    problem = PL_B_std()

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
    F6 = f6(res.X)
    F7 = f7(res.X)
    F8 = f8(res.X)
    F9 = f9(res.X)

	PF = np.column_stack([res.F, F4, F5, F6, F7, F8, F9])

	save_front(PF, "../outputs/NSGA-III/PL_B_pre_"+str(i+1)+".bin", [3,3,3])

def optimize_moead(i):

    problem = PL_B_std()

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
    F6 = f6(res.X)
    F7 = f7(res.X)
    F8 = f8(res.X)
    F9 = f9(res.X)
    
	PF = np.column_stack([res.F, F4, F5, F6, F7, F8, F9])

	save_front(PF, "../outputs/MOEAD/PL_B_pre_"+str(i+1)+".bin", [3,3,3])
            
def optimize_nsga2(i):

    problem = PL_B_std()

    algorithm = NSGA2(pop_size = 100)

    termination = get_termination("n_gen", 500)

    res = minimize(problem,
                   algorithm,
                   termination,
                   save_history=False,
                   verbose=False)
                   
    F4 = f4(res.X)
    F5 = f5(res.X)
    F6 = f6(res.X)
    F7 = f7(res.X)
    F8 = f8(res.X)
    F9 = f9(res.X)

	PF = np.column_stack([res.F, F4, F5, F6, F7, F8, F9])

	save_front(PF, "../outputs/NSGA-II/PL_B_pre_"+str(i+1)+".bin", [3,3,3])



if __name__ == '__main__':
    with Pool(8) as p:
        p.map(optimize_moead, range(50))

    with Pool(8) as p:
        p.map(optimize_nsga2, range(50))

    with Pool(8) as p:
        p.map(optimize_nsga3, range(50))
