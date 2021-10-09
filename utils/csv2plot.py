import numpy as np
import matplotlib.pyplot as plt

def display_front(filename, num_figure, benchmark):
	F = np.loadtxt(open("../fronts/"+filename+".csv", "rb"), delimiter=",", skiprows=0)
	fig = plt.figure(num_figure, figsize=(8,6))
	ax = fig.add_subplot(projection='3d')
	ax.w_xaxis.set_pane_color((1,1,1,1))
	ax.w_yaxis.set_pane_color((1,1,1,1))
	ax.w_zaxis.set_pane_color((1,1,1,1))

	if benchmark=="PL-C":
		ax.view_init(45,10)
		ax.set_xlim(0,10.6)
		ax.set_ylim(0,10.6)
		ax.set_zlim(0,6.5)
		ax.set_xlabel("$x_1$")
		ax.set_ylabel("$x_2$")
		ax.set_zlabel("$g(x)$")

	elif benchmark=="MaF7":
		ax.view_init(45,45)
		#ax.set_xlim(0,10.6)
		#ax.set_ylim(0,10.6)
		ax.set_zlim(2.5,5.5)
		ax.set_xlabel("$f_1$")
		ax.set_ylabel("$f_2$")
		ax.set_zlabel("$f_3$")

	elif benchmark=="MaF11":
		ax.view_init(45,45)
		ax.set_xlabel("$f_1$")
		ax.set_ylabel("$f_2$")
		ax.set_zlabel("$f_3$")

	ax.scatter(F[:,0], F[:,1], F[:,2], alpha=1) #edgecolors="black"
	plt.show()

#display_front("PL_C_1", 1)
#display_front("PL_C_2", 2)
#display_front("PL_C_3", 3)

#display_front("MaF7_MOEAD", 1, "MaF7")

#display_front("MaF11_SCHMIEDLE", 1, "MaF11")
display_front("MaF11_MOEAD", 1, "MaF11")
