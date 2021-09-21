import numpy as np
from pymoo.model.problem import Problem
from math import pi
from utils import GAA_cost_function

class PL_A(Problem):

	def __init__(self):
		super().__init__(n_var=3,
							n_obj=5,
							n_constr=0,
							xl=np.zeros(3),
							xu=5*np.ones(3))

	def _evaluate(self, X, out, *args, **kwargs):
		
		g = (X[:,2]-5*(1-((X[:,0]-2)**2+(X[:,1]-2)**2)/(9+(X[:,0]-2)**2+(X[:,1]-2)**2)))**2

		f1 = np.cos(pi*X[:,0]/10)*np.cos(pi*X[:,1]/10)
		f2 = np.cos(pi*X[:,0]/10)*np.sin(pi*X[:,1]/10)
		f3 = np.sin(pi*X[:,0]/10)+g
		f4 = ((X[:,0]-2)**2+(X[:,1]-2)**2-1)**2
		f5 = ((X[:,0]-2)**2+(X[:,1]-2)**2-3)**2

		out["F"] = np.column_stack([f1, f2, f3, f4, f5])
		out["G"] = 0
        

class PL_A_std(Problem):

	def __init__(self):
		super().__init__(n_var=3,
							n_obj=3,
							n_constr=0,
							xl=np.zeros(3),
							xu=5*np.ones(3))

	def _evaluate(self, X, out, *args, **kwargs):
		
		g = (X[:,2]-5*(1-((X[:,0]-2)**2+(X[:,1]-2)**2)/(9+(X[:,0]-2)**2+(X[:,1]-2)**2)))**2

		f1 = np.cos(pi*X[:,0]/10)*np.cos(pi*X[:,1]/10)
		f2 = np.cos(pi*X[:,0]/10)*np.sin(pi*X[:,1]/10)
		f3 = np.sin(pi*X[:,0]/10)+g

		out["F"] = np.column_stack([f1, f2, f3])
		out["G"] = 0


class PL_B(Problem):

    def __init__(self):
        super().__init__(n_var=3,
                         n_obj=9,
                         n_constr=0,
                         xl=np.zeros(3),
                         xu=np.ones(3))

    def _evaluate(self, X, out, *args, **kwargs):
    
        alpha = 2.5
        beta = 10
        g = beta*(X[:,2]-X[:,0])**2
    
        f1 = (1-X[:,0]*X[:,1])*(1+g)
        f2 = (1-X[:,0]*(1-X[:,1]))*(1+g)
        f3 = X[:,0]*(1+g)
        
        f4 = np.cos(pi*X[:,0]/2)*np.cos(pi*X[:,1]/2)+beta*(X[:,0]**(alpha*X[:,2])-X[:,1])**2
        f5 = np.cos(pi*X[:,0]/2)*np.sin(pi*X[:,1]/2)+beta*(X[:,0]**(alpha*X[:,2])-X[:,1])**2
        f6 = np.sin(pi*X[:,0]/2)+beta*(X[:,0]**(alpha*X[:,2])-X[:,1])**2
        
        f7 = np.cos(pi/3*(X[:,0]+X[:,2]-1))
        f8 = np.cos(pi*4/3*(X[:,0]+X[:,2]))
        f9 = 1/(1+0.3*(X[:,0]+X[:,2]-1)**2)-2/(1+1750*(X[:,0]+X[:,2]-1)**2)

        out["F"] = np.column_stack([f1, f2, f3, f4, f5, f6, f7, f8, f9])
        out["G"] = 0


class PL_B_std(Problem):

    def __init__(self):
        super().__init__(n_var=3,
                         n_obj=3,
                         n_constr=0,
                         xl=np.zeros(3),
                         xu=np.ones(3))

    def _evaluate(self, X, out, *args, **kwargs):
    
        alpha = 2.5
        beta = 10
        g = beta*(X[:,2]-X[:,0])**2
    
        f1 = (1-X[:,0]*X[:,1])*(1+g)
        f2 = (1-X[:,0]*(1-X[:,1]))*(1+g)
        f3 = X[:,0]*(1+g)

        out["F"] = np.column_stack([f1, f2, f3])
        out["G"] = 0

class PL_C(Problem):

        def __init__(self):
            super().__init__(n_var=2,
                             n_obj=8,
                             n_constr=0,
                             xl=np.zeros(2),
                             xu=np.ones(2)*10)
        
        def _evaluate(self, X, out, *args, **kwargs):
        
            p = np.ones((np.size(X, axis=0), self.n_var))
            p1 = p*5 #4
            p2 = p*[10, 6]
            p3 = p*[6,10]
    
            r = np.sqrt(X[:,0]**2+X[:,1]**2)
        
            f1 = X[:,0]
            f2 = X[:,1]
            f3 = 10*(np.exp(-r) / (1 + np.exp(-r))) * (0.3 + np.cos(2*r)**2)
            
            f4 =  np.cos(2*r)
            f5 = -np.sin(2*r)
            
            f6 = np.linalg.norm(X-p1, axis=1)
            f7 = np.linalg.norm(X-p2, axis=1)
            f8 = np.linalg.norm(X-p3, axis=1)

            out["F"] = np.column_stack([f1, f2, f3, f4, f5, f6, f7, f8])
            out["G"] = 0
            
class PL_C_std(Problem):

        def __init__(self):
            super().__init__(n_var=2,
                             n_obj=3,
                             n_constr=0,
                             xl=np.zeros(2),
                             xu=np.ones(2)*10)
        
        def _evaluate(self, X, out, *args, **kwargs):
    
            r = np.sqrt(X[:,0]**2+X[:,1]**2)
        
            f1 = X[:,0]
            f2 = X[:,1]
            f3 = 10*(np.exp(-r) / (1 + np.exp(-r))) * (0.3 + np.cos(2*r)**2)

            out["F"] = np.column_stack([f1, f2, f3])
            out["G"] = 0

class MPL_GAA(Problem):

	def __init__(self):
		super().__init__(n_var=27,
							n_obj=10,
							n_constr=1,
							xl=np.array([0.24, 7.0, 0.0, 5.5, 19.0, 85.0, 14.0, 3.0, 0.46, 0.24, 7.0, 0.0, 5.5, 19.0, 85.0, 14.0, 3.0, 0.46, 0.24, 7.0, 0.0, 5.5, 19.0, 85.0, 14.0, 3.0, 0.46]),
							xu=np.array([0.48, 11.0, 6.0, 5.968, 25.0, 110.0, 20.0, 3.75, 1, 0.48, 11.0, 6.0, 5.968, 25.0, 110.0, 20.0, 3.75, 1, 0.48, 11.0, 6.0, 5.968, 25.0, 110.0, 20.0, 3.75, 1]))

	def _evaluate(self, X, out, *args, **kwargs):

		const, cost = GAA_cost_function(X)

		out["F"] = cost
		out["G"] = const


class MaF11(Problem):

    def __init__(self):
        super().__init__(n_var=12,
                         n_obj=5,
                         n_constr=0,
                         xl=np.zeros(12),
                         xu=np.array([2*i for i in range(1,13)]))

    def _evaluate(self, X, out, *args, **kwargs):
    
        z = lambda i : X[:,i-1]/(2*i)
        
        t1 = lambda i : z(i) if (i<=2) else np.abs(z(i)-0.35)/(np.abs(np.floor(0.35-z(i)))+0.35)
        
        t2 = lambda i : t1(i) if (i<=2) else t1(2+2*(i-2)-1) + t1(2+2*(i-2)) + 2*np.abs(t1(2+2*(i-2)-1)-t1(2+2*(i-2)))
        
        t3 = lambda i : t2(i) if (i<=2) else sum([t2(j) for j in range(3, 7)])/5
        
        y = lambda i : (t3(i)-0.5)*np.maximum(1,t3(3))+0.5 if (i<=2) else t3(3)
        
        y1 = y(1)
        y2 = y(2)
        y3 = y(3)
    
        f1 = y3 + 2*(1-np.cos(pi*y1/2))*(1-np.cos(pi*y2/2))
        f2 = y3 + 4*(1-np.cos(pi*y1/2))*(1-np.sin(pi*y2/2))
        f3 = y3 + 6*(1-y1*np.cos(5*pi*y1)**2)
        f4 = y3 + 2*(1-np.cos(pi*y1/2))*(1-np.cos(pi*y2/2))
        f5 = y3 + 4*(1-np.cos(pi*y1/2))*(1-np.sin(pi*y2/2))

        out["F"] = np.column_stack([f1, f2, f3, f4, f5])
        out["G"] = 0

class MaF11_std(Problem):

    def __init__(self):
        super().__init__(n_var=12,
                         n_obj=3,
                         n_constr=0,
                         xl=np.zeros(12),
                         xu=np.array([2*i for i in range(1,13)]))

    def _evaluate(self, X, out, *args, **kwargs):
    
        z = lambda i : X[:,i-1]/(2*i)
        
        t1 = lambda i : z(i) if (i<=2) else np.abs(z(i)-0.35)/(np.abs(np.floor(0.35-z(i)))+0.35)
        
        t2 = lambda i : t1(i) if (i<=2) else t1(2+2*(i-2)-1) + t1(2+2*(i-2)) + 2*np.abs(t1(2+2*(i-2)-1)-t1(2+2*(i-2)))
        
        t3 = lambda i : t2(i) if (i<=2) else sum([t2(j) for j in range(3, 7)])/5
        
        y = lambda i : (t3(i)-0.5)*np.maximum(1,t3(3))+0.5 if (i<=2) else t3(3)
    
        f1 = y(3) + 2*(1-np.cos(pi*y(1)/2))*(1-np.cos(pi*y(2)/2))
        f2 = y(3) + 4*(1-np.cos(pi*y(1)/2))*(1-np.sin(pi*y(2)/2))
        f3 = y(3) + 6*(1-y(1)*np.cos(5*pi*y(1))**2)

        out["F"] = np.column_stack([f1, f2, f3])
        out["G"] = 0


class MaF7(Problem):

    def __init__(self):
        super().__init__(n_var=3,
                         n_obj=5,
                         n_constr=0,
                         xl=np.array([0,0,0]),
                         xu=np.array([1,1,20]))

    def _evaluate(self, X, out, *args, **kwargs):
        f1 = X[:,0]
        f2 = X[:,1]
        f3 = 3*(2+9/20*X[:,2])-X[:,0]*(1+np.sin(3*X[:,0]*pi))-X[:,1]*(1+np.sin(3*X[:,1]*pi))
        f4 = -np.exp(-0.5*((X[:,0]-0.6)**2+(X[:,1]-0.6)**2))
        f5 = abs((X[:,0]-0.8)**2+(X[:,1]-0.8)**2-0.2**2)

        out["F"] = np.column_stack([f1, f2, f3, f4, f5])
        out["G"] = 0


class Crash(Problem):
    
    def __init__(self):
        super().__init__(n_var=5,
                         n_obj=3,
                         n_constr=0,
                         xl=np.array([1,1,1,1,1]),
                         xu=np.array([3,3,3,3,3]))

    def _evaluate(self, X, out, *args, **kwargs):
        f1 = 1640.2823 + 2.3573285*X[:,0] + 2.3220035*X[:,1] + \
            4.5688768*X[:,2] + 7.7213633*X[:,3] + 4.4559504*X[:,4];
        f2 = 6.5856 + 1.15*X[:,0] - 1.0427*X[:,1] + 0.9738*X[:,2] + \
            0.8364*X[:,3] - 0.3695*X[:,0]*X[:,3] + 0.0861*X[:,0]*X[:,4] + \
            0.3628*X[:,1]*X[:,3] - 0.1106*X[:,0]*X[:,0] - 0.3437*X[:,2]*X[:,2] + \
            0.1764*X[:,3]*X[:,3];
        f3 = -0.0551 + 0.0181*X[:,0] + 0.1024*X[:,1] + 0.0421*X[:,2] - \
            0.0073*X[:,0]*X[:,1] + 0.024*X[:,1]*X[:,2] - 0.0118*X[:,1]*X[:,3] - \
            0.0204*X[:,2]*X[:,3] - 0.008*X[:,2]*X[:,4] - 0.0241*X[:,1]*X[:,1] + \
            0.0109*X[:,3]*X[:,3];

        out["F"] = np.column_stack([f1, f2, f3])
        out["G"] = 0


class MaF7_std(Problem):

	def __init__(self):
		super().__init__(n_var=3,
                         n_obj=3,
                         n_constr=0,
                         xl=np.array([0,0,0]),
                         xu=np.array([1,1,20]))

	def _evaluate(self, X, out, *args, **kwargs):
		f1 = X[:,0]
		f2 = X[:,1]
		f3 = 3*(2+9/20*X[:,2])-X[:,0]*(1+np.sin(3*X[:,0]*pi))-X[:,1]*(1+np.sin(3*X[:,1]*pi))

		out["F"] = np.column_stack([f1, f2, f3])
		out["G"] = 0

class debug_PL_B(Problem):

	def __init__(self):
		super().__init__(n_var=3,
                         n_obj=3,
                         n_constr=0,
                         xl=np.zeros(3),
                         xu=np.ones(3))

	def _evaluate(self, X, out, *args, **kwargs):
		
		alpha = 2.5
		beta = 10

		f4 = np.cos(pi*X[:,0]/2)*np.cos(pi*X[:,1]/2)+beta*(X[:,0]**(alpha*X[:,2])-X[:,1])**2
		f5 = np.cos(pi*X[:,0]/2)*np.sin(pi*X[:,1]/2)+beta*(X[:,0]**(alpha*X[:,2])-X[:,1])**2
		f6 = np.sin(pi*X[:,0]/2)+beta*(X[:,0]**(alpha*X[:,2])-X[:,1])**2

		out["F"] = np.column_stack([f4, f5, f6])
		out["G"] = 0
