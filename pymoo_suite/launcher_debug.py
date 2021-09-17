from problems import debug_PL_B
from pymoo.algorithms.nsga2 import NSGA2
from pymoo.factory import get_termination
from pymoo.optimize import minimize
import numpy as np
import matplotlib.pyplot as plt

def optimize_nsga2():
	problem = debug_PL_B()

	algorithm = NSGA2(pop_size = 300)

	termination = get_termination("n_gen", 500)

	res = minimize(problem,
                   algorithm,
                   termination,
                   save_history=False,
                   verbose=False)

	fig = plt.figure()
	ax = fig.add_subplot(projection='3d')
	ax.scatter(res.F[:,0], res.F[:,1], res.F[:,2])
	plt.show()

if __name__ == '__main__':
	optimize_nsga2()
