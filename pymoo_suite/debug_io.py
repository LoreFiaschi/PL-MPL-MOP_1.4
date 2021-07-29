import numpy as np
import pymoo_suite.utils as u

level_size =[2,3,3,2]
filename = "prova_io.bin"
pop = np.random.rand(2,10)

u.save_front(pop, filename, level_size)
