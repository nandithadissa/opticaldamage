import numpy as np
import matplotlib.pyplot as plt

def gaussian(x,A=1,B=0,W=1):
    #x = np.arange(-5,5,0.1)
    y = A*np.exp(-2*(x-B)**2/W**2)    
    #plt.plot(x,y)
    #plt.show()
    return x,y

#x = np.arange(-5,5,0.1)
#x,y=gaussian(x)


def tophat(x,A=1,B=1):
    
    def val(x):
        if abs(x) < B/2:
            return A
        else :
            return 0 

    #x = np.arange(-1,1,0.1)
    y = np.array([val(i) for i in x]) 

    #########################
    # Here B needs to be the width of the step
    # define a heavyside function and if x/2>B/2 y = 0

    #plt.plot(x,y)
    return x,y

def erf(x,y):
    #x,y=gaussian()
    #z=[np.trapz(y[0:i],x[0:i]) for i in range(0,np.size(x))]
    z=[np.trapz(y[0:i],x[0:i]) for i in range(0,np.size(x))]
    #plt.plot(x,z)
    #plt.show()
    return x,z

def tophat_integral(x,y):
    z=[np.trapz(y[0:i],x[0:i]) for i in range(0,np.size(x))]
    #plt.plot(x,z)
    return x,z

#test
#erf(x,y) 



from scipy.optimize import curve_fit

def plot(filename):
    data = np.genfromtxt(filename, delimiter=",", skip_header=1)
    x = data[20:,0] - 5.0
    y = data[20:,1] * 1000
    plt.plot(x,y)
    


    #x,y_fit=tophat(x,A=1,B=1)
    #tophat_integral(x,y_fit)
    
    def func_gaussian(x,A,B,W): #A-peak, W=width
        x,y_fit=gaussian(x,A,B,W)
        x,z_fit=erf(x,y_fit)
        return z_fit

  
    def gaussian_fit(x,y):
        A,B,W=6.5,0,0.5 
        #x = np.arange(-2,2,0.1)
        #zfit = func_gaussian(x,A,B,W)
        #plt.scatter(x[1:],zfit[1:])
        plt.xlabel("d (mm)")
        plt.ylabel("P (mW)")

        popt,pcov = curve_fit(func_gaussian,x,y)
        A,B,W = popt
        print(A,B,W)
        zfit = func_gaussian(x,A,B,W)
        plt.plot(x,zfit)
        #plt.scatter(x[1:],zfit[1:])
        x,y_fit=gaussian(x,A,B,W)
        plt.plot(x,y_fit,'-.')
        return

    def tophat_fit(x,y):

        def func_tophat(x,A,B): #A-peak, B=width
            x,y_fit=tophat(x,A,B)
            x,z_fit=tophat_integral(x,y_fit)
            return z_fit

        A=4000
        B=0.1
        #x = np.arange(-2,2,0.1)
        #zfit = func_tophat(x,A)
        #plt.scatter(x[1:],zfit[1:])
        plt.xlabel("d (mm)")
        plt.ylabel("P (mW)")

        popt,pcov = curve_fit(func_tophat,x,y)
        A,B = popt
        print(A,B)
        zfit = func_tophat(x,A,B)
        plt.plot(x,zfit)
        #plt.scatter(x[1:],zfit[1:])
        x,y_fit=tophat(x,A,B)
        plt.plot(x,y_fit,'g--')
        return

    tophat_fit(x,y)
    gaussian_fit(x,y)

    return 

#plot("beamcrosssection.txt")
#plot("beam-121221.txt")
#plot("beam-010422.txt")
plot("beamwidth-diffuser-PRF-10KHz_1_beamwidth.txt")
plt.xlim(-1,1)
plt.show()
