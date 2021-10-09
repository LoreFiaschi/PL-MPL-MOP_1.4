from problems import PL_C_std#, MaF7_std, MaF11_std
from pymoo.algorithms.moo.nsga2 import NSGA2
from pymoo.factory import get_termination, get_reference_directions
from pymoo.optimize import minimize
from utils import postfiltering
import numpy as np
from math import pi

def PL_C_front():

	n_var = 2

	r  = lambda X : np.sqrt(X[:,0]**2+X[:,1]**2)

	f4 = lambda X : np.cos(2*r(X))
	f5 = lambda X : -np.sin(2*r(X))

	f6 = lambda X : np.linalg.norm(X-(np.ones((np.size(X, axis=0), n_var))*4), axis=1)
	f7 = lambda X : np.linalg.norm(X-(np.ones((np.size(X, axis=0), n_var))*[10, 6]), axis=1)
	f8 = lambda X : np.linalg.norm(X-(np.ones((np.size(X, axis=0), n_var))*[6, 10]), axis=1)

	problem = PL_C_std()

	algorithm = NSGA2(pop_size = 500)

	termination = get_termination("n_gen", 1000)

	res = minimize(problem,
		           algorithm,
		           termination,
		           save_history=False,
		           verbose=False)

	np.savetxt("../fronts/PL_C_1.csv", res.F, delimiter=",")	
		           
	F4 = f4(res.X)
	F5 = f5(res.X)
	F6 = f6(res.X)
	F7 = f7(res.X)
	F8 = f8(res.X)

	PF = np.column_stack([res.F, F4, F5])

	PF = postfiltering(PF, [[True, True, True, False, False], [False, False, False, True, True]])

	np.savetxt("../fronts/PL_C_2.csv", PF[:,0:2], delimiter=",")

	PF = np.column_stack([res.F, F4, F5, F6, F7, F8])

	PF = postfiltering(PF, [[True, True, True, False, False, False, False, False],\
								[False, False, False, True, True, False, False, False],\
								[False, False, False, False, False, True, True, True]])

	np.savetxt("../fronts/PL_C_3.csv", PF[:,0:2], delimiter=",")



if __name__ == '__main__':
	PL_C_front()
