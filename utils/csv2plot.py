import numpy as np

from pymoo.visualization.scatter import Scatter
from pymoo_suite.utils import postfiltering
import matplotlib as mplt

mplt.rcParams["font.size"]=20
#mplt.rcParams["figure.autolayout"]=True
mplt.rcParams["legend.fontsize"]="small"
mplt.rcParams["legend.loc"] = 'upper right'

#plot = Scatter(legend="true",labels=["mass","acceleration"])
plot = Scatter(legend="true",labels=["acceleration","toe-board intrusion resistance"])
#plot = Scatter(legend="true",labels=["\n\nmass","\n\nacceleration","\n\ntoe-board intrusion resistance"])
#plot = Scatter(legend="true")
#plot = Scatter()

#F = np.loadtxt(open("Fronts/Crash/MaF7_PLNSGAII.csv", "rb"), delimiter=",", skiprows=1)
#F = np.loadtxt(open("Fronts/Crash/MaF11_PLNSGAII.csv", "rb"), delimiter=",", skiprows=1)
#F = np.loadtxt(open("Fronts/Crash/Crash_PLNSGAII.csv", "rb"), delimiter=",", skiprows=1)
#F = np.loadtxt(open("Fronts/Crash/Crash_PLNSGAII_0.csv", "rb"), delimiter=",", skiprows=1)
#plot.add(F, color='blue', label="PL-NSGA-II")
#plot.add(F, color='red', marker="s", label="Prioritized Pareto Front")

#F = np.loadtxt(open("Fronts/Crash/DEB.csv", "rb"), delimiter=",", skiprows=1)
#plot.add(F, color='red', label="DEB")

#F = np.loadtxt(open("Fronts/Crash/MOEAD_post.csv", "rb"), delimiter=",", skiprows=1)
#plot.add(F, color='red', label="MOEAD_post")


F = np.loadtxt(open("Fronts/Crash/Crash_Deb.csv", "rb"), delimiter=",", skiprows=0)
#F = np.loadtxt(open("Fronts/Crash/Crash_NSGAII.csv", "rb"), delimiter=",", skiprows=0)
#F = np.loadtxt(open("Fronts/Crash/Crash_NSGAIII.csv", "rb"), delimiter=",", skiprows=0)
#plot.add(F, color='green', label="True")


#F = np.loadtxt(open("Fronts/Crash/Crash_NSGAII_2500.csv", "rb"), delimiter=",", skiprows=0)
#F = np.loadtxt(open("Fronts/Crash/Crash_NSGAII_2500_post.csv", "rb"), delimiter=",", skiprows=0)
#F = np.loadtxt(open("Fronts/Crash/Crash_NSGAIII_2500.csv", "rb"), delimiter=",", skiprows=0)
#F = np.loadtxt(open("Fronts/Crash/Crash_NSGAIII_2500_post.csv", "rb"), delimiter=",", skiprows=0)

#plot.add(F, color='blue', marker="X", label="Un-prioritized Pareto Front")

#plot.add(np.column_stack([F[:,1], F[:,2]]), color="blue", marker="X", label="Solutions sub-optimal in first PL")
#plot.add(np.column_stack([F[:,1], F[:,2]]), color="blue", marker="X", label="Solutions sub-optimal in second PL")

#F_n_opt = postfiltering(F,[[False,True,True]])
#plot.add(np.column_stack([F_n_opt[:,1], F_n_opt[:,2]]), color="magenta", marker="D", label="Solutions optimal only in second PL")

idx = np.where(F[:,0]<1680)
F = F[idx[0],:]
idx = np.where(F[:,1]<9)
F = F[idx[0],:]
idx = np.where(F[:,2]>0.06)
F = F[idx[0],:]


F_opt = postfiltering(F,[[True, True, False]])
plot.add(np.column_stack([F_opt[:,1], F_opt[:,2]]), color="limegreen", label="Solutions optimal in first PL and sub-optimal in second PL")
F_opt_opt = postfiltering(F_opt,[[False, True, True]])
plot.add(np.column_stack([F_opt_opt[:,1], F_opt_opt[:,2]]), color="red", marker="s", label="First PL solutions optimal in second PL")
#plot.add(F_opt, color='red', marker="s", label="Prioritized Pareto Front")



#F = np.loadtxt(open("Fronts/Crash/MaF11/MaF11_MOEAD.csv", "rb"), delimiter=",", skiprows=1)
#F = np.loadtxt(open("Fronts/Crash/MaF11/MaF11_SCHMIEDLE.csv", "rb"), delimiter=",", skiprows=1)

#plot.add(np.transpose(F))

plot.show()
"""
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

F1 = np.loadtxt(open("Fronts/Crash/Crash_Deb.csv", "rb"), delimiter=",", skiprows=0)

#F2 = np.loadtxt(open("Fronts/Crash/Crash_NSGAIII_2500.csv", "rb"), delimiter=",", skiprows=0)
#F2 = np.loadtxt(open("Fronts/Crash/Crash_NSGAIII_2500_post.csv", "rb"), delimiter=",", skiprows=0)
F2 = np.loadtxt(open("Fronts/Crash/Crash_NSGAII_2500.csv", "rb"), delimiter=",", skiprows=0)
#F2 = np.loadtxt(open("Fronts/Crash/Crash_NSGAII_2500_post.csv", "rb"), delimiter=",", skiprows=0)


fig = plt.figure()

ax = fig.add_subplot(121, projection='3d')
ax.scatter3D(F1[:,0], F1[:,1], F1[:,2], color="red", label="Deb", marker=".")
ax.scatter3D(F2[:,0], F2[:,1], F2[:,2], color="green", label="NSGA-II", marker=".")
ax.legend()
ax.set_xlabel('f_1')
ax.set_ylabel('f_2')
ax.set_zlabel('f_3')

ax = fig.add_subplot(122, projection='3d')
ax.scatter3D(F1[:,0], F1[:,1], F1[:,2], color="red", label="Deb", marker=".")
ax.scatter3D(F2[:,0], F2[:,1], F2[:,2], color="green", label="NSGA-II", marker=".")
ax.legend()
ax.set_xlabel('f_1')
ax.set_ylabel('f_2')
ax.set_zlabel('f_3')

plt.show()
"""
