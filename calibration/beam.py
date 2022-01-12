import numpy as np
import matplotlib.pyplot as plt


    
#plot("beam-width.txt")
#plt.show()

def gaussian(x,A=1,B=0,W=1):
    #x = np.arange(-5,5,0.1)
    y = A*np.exp(-2*(x-B)**2/W**2)    
    #plt.plot(x,y)
    #plt.show()
    return x,y

#x = np.arange(-5,5,0.1)
#x,y=gaussian(x)


def erf(x,y):
    #x,y=gaussian()
    #z=[np.trapz(y[0:i],x[0:i]) for i in range(0,np.size(x))]
    z=[np.trapz(y[0:-i],x[0:-i]) for i in range(0,np.size(x))]
    #plt.plot(x,z)
    #plt.show()
    return x,z

#test
#erf(x,y) 

from scipy.optimize import curve_fit

def plot(filename):
    data = np.genfromtxt(filename, delimiter="\t", skip_header=1)
    x = data[:,0] 
    y = data[:,1]
    #plt.plot(x,y)

    def func(x,A,B,W): #A-peak, W=width
        x,y_fit=gaussian(x,A,B,W)
        x,z_fit=erf(x,y_fit)
        return z_fit 

    A,B,W=6.5,0,1.25 
    #x = np.arange(-2,2,0.1)
    #zfit = func(x,A,B,W)
    #plt.scatter(x[1:],zfit[1:])
    plt.xlabel("d (mm)")
    plt.ylabel("I (uW)")

    popt,pcov = curve_fit(func,x,y)
    A,B,W = popt
    print(A,B,W)
    zfit = func(x,A,B,W)
    #plt.scatter(x[1:],zfit[1:])
    x,y_fit=gaussian(x,A,B,W)
    plt.plot(x,y_fit)
        
    return 

plot("beam-width.txt")
plt.show()