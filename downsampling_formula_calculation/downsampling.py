from matplotlib import pyplot as plt
import numpy as np





x=[]
y=[]
c=[]
#maximal downsampling ratio
Rmax = 64




#write the fomulas from thesis to get the changed Rj

#K,sigma,xbar,gbar -> fRj -> C(i) -> T(i) -> Down(Rj) -> Rj+1 to get selective downsampling Ratios

######################################################################################################
#The length of each group Rj
def Rjfun(j):
    return int(2**j)
######################################################################################################

#formula (2.9) xbar
def xbar(Rj,x):
    return np.sum(x)/Rj

######################################################################################################

#formula (2.10) gbar
def gbar(Rj,x):
    return 2*np.sum(x[:x.size//2])/Rj

######################################################################################################

#（2.10） defination fRj
def fRj(x,j,K,sigma):
    return (np.abs(xbar(Rjfun(j),x)-gbar(Rjfun(j),x))) <= K*sigma/np.sqrt(float(Rjfun(j)))

######################################################################################################

#(2.4) C(i)
def Cfun(x,K,sigma):
    c=[]
    for j in range(1,7): #set the Lmax=64
        c.append(fRj(x[0:2**j],j,K,sigma))
    return c

######################################################################################################

#(2.4) T(i)
def Tfun(k,x,K,sigma):
    C = Cfun(x,K,sigma)
    T = np.zeros_like(C)
    T[0] = C[0]
    for i in range(1,len(C)):
        T[i] = T[i-1] and C[i]
    return T[k-2]

######################################################################################################

#(2.8) Down(Rj), the result is true or false
def DownR(j,x,K,sigma):
    T = True
    for n in range (0,Rjfun(j)):
        for k in range (2,2+j):
            #print(n,k,T)
            T = T and Tfun(k,x[2*Rjfun(j)+n-2**k:],K,sigma)
    return not(T)

######################################################################################################

#next selective Ratio after Rj, 3 conditions 
def fRj_1(j,x,K,sigma):
    if (Rjfun(j) >1) and DownR(j,x,K,sigma):
        # print(0.5*Rjfun(j))
        # print("@@")
        return j-1

    elif (Rjfun(j) != Rmax) and (not(DownR((j+1),x,K,sigma))):
        # print("##")
        return j+1
        
    else:
        # print("##")
        return j
######################################################################################################       
###################################################################################################### 

#import the date of website, file "wave" and delete the line breaks
a_file = open("wave.txt", "r")

string_without_line_breaks = ""
for line in a_file:
  stripped_line = line.rstrip()
  string_without_line_breaks += stripped_line
a_file.close()

######################################################################################################
###################################################################################################### 

# delte the data comma
msg = string_without_line_breaks
z = [int(x.strip()) for x in msg.split(',')]
y = np.array(z)
x = np.arange(0,y.size) #x axis 
print(y)

######################################################################################################



j = 3 #initial sample group length
i = 0
K = 1.4 # to set trigger level
sigma =20 # to set STD sigma
X = []# for mean value of sample groups
count =0
S = []# for STD
I = []# for x axis
J = []# for changed group length


# when the left downsamling samples is smaller than the total original data, achiving 997, 3 samples left, original data is 1000 totally
while i +(2**j)-1 < y.size: 
    j = fRj_1(j,y[i:],K,sigma)# get the next sample group length
    J.append(j) 
    
    Y = y[i:i+2**j]#data alreday downsampled
    print("Y: ",Y)
    I.append(i+(2**j-1)/2)# The x axis of mean value in figure, the middle value between first sample and last sample in one group  
    
    X.append(np.mean(Y)) #get the mean of groups of samples
    S.append(np.std(Y))  #get the STD of groups of samples
    print("j,i, X[i],S[i]: ",j,i)
    
    i+=2**j #next start to downsampling data

    
X = np.array(X)
S = np.array(S)
I = np.array(I)


#print(X.shape,S.shape,I.shape)
plt.figure()
plt.plot(x,y,'o',label='originial data')
plt.errorbar(I,X,1.4*S,xerr=None,fmt='+',label='reconstructeda')
plt.xlabel('x')
plt.ylabel('y')
plt.title('test data from vhdl file')
plt.legend()
plt.figure()
plt.plot(I,J,label='ratio')#figure 2
plt.figure()
plt.plot(I,S,label='std')#rfigure 3
plt.show()
