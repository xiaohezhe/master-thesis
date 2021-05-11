import numpy as np
import matplotlib.pyplot as plt
import matplotlib





x=[]
y=[]
c=[]
#maximal downsampling ratio
Rmax = 4




#write the fomulas from thesis to get the changed Rj

#K,sigma,xbar,gbar -> fRj -> C(i) -> T(i) -> Down(Rj) -> Rj+1 to get selective downsampling Ratios

######################################################################################################
#The length of each group Rj
def Rjfun(j):
    return int(2**j)
######################################################################################################

#formula (2.9) xbar
def xbar(Rj,x):
    ##return np.sum(x)/Rj
    return np.sum(x)
######################################################################################################

#formula (2.10) gbar
def gbar(Rj,x):
    #return 2*np.sum(x[:x.size//2])/Rj
    return 2*np.sum(x[:x.size//2])

######################################################################################################

#（2.10） defination fRj
def fRj(x,j,K,sigma):
    ##return (np.abs(xbar(Rjfun(j),x)-gbar(Rjfun(j),x))) <= K*sigma/np.sqrt(float(Rjfun(j)))
    mulvec = [1, 2, 3, 4, 6, 8]
    return (np.abs(xbar(Rjfun(j),x)-gbar(Rjfun(j),x))) <= K*sigma*mulvec[j-1]
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
    for k in range (2,2+j):
        for n in range (0,Rjfun(j)):
            T = T and Tfun(k,x[2*Rjfun(j)+n-2**k:],K,sigma)
            #print(j,n,k,2*Rjfun(j)+n-2**k,2*Rjfun(j)+n-2**k,x[2*Rjfun(j)+n-2**k],Tfun(k,x[2*Rjfun(j)+n-2**k:],K,sigma),T)
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
#print("y STD, Mean:",np.std(y[:200]),np.mean(y[:200]))

######################################################################################################

# f1 = open("tb_data_newcompressor1.csv","r")
# lines1=f1.readlines()
# y1=[]

# for i_1 in (lines1):
#     y1.append(int(i_1))   
# f1.close()

# y=np.array(y1)

# print(y)

j = 2 #initial sample group length
i = 0
K = 2 # to set trigger level
sigma =8 # to set STD sigma
X = []# for mean value of sample groups
count =0
j_curr =0
S = []# for STD
I = []# for x axis
J = []# for changed group length

Ix = []# for x axis
sub_2=[]
# when the left downsamling samples is smaller than the total original data, achiving 997, 3 samples left, original data is 1000 totally
while i +(2**j)-1 < y.size: 
    # print(i)
    j = fRj_1(j,y[i:],K,sigma)# get the next sample group length
    Y = y[i:i+2**j]#data alreday downsampled
    print(abs(sum(Y)-2*sum(Y[:len(Y)//2])))
    sub_2.append(abs(sum(Y)-2*sum(Y[:len(Y)//2])))
    # J.append(j) 
    # print("Y: ",Y)
    #I.append(i+(2**j-1)/2)# The x axis of mean value in figure, the middle value between first sample and last sample in one group  
    I.append(i)
    #np.floor, get round values,向下取值

    if count >= 2**j_curr-1:
        # X.append(np.floor(np.sum(Y))) #temporary fix for comparison
        X.append((np.mean(Y))) #get the mean of groups of samples
        Ix.append(i)
        J.append(j) 

        j_curr=j
        count=0
    else:
        count+=1
    S.append(np.std(Y))  #get the STD of groups of samples
    # print("j,i, X[i],S[i]: ",j,i)
    
    # i+=2**j #next start to downsampling data
    i+=1 #next start to downsampling data
    if i>80:
         break
    
X = np.array(X)
S = np.array(S)
I = np.array(I)
sub_2=np.array(sub_2)
np.savetxt('/home/hezhe/Documents/old_filter_new/new_compressor/tb_data_newcompressor.csv',y,fmt='%i',delimiter=',')

f = open("/home/hezhe/Documents/old_filter_new/new_compressor/ratio_out.txt","r")
lines=f.readlines()
ratio_out1=[]
comprsser_out=[]
comprsser_count=[]
temp_i = 0
plot_count = []
first = True
offset = 0
for i,j in enumerate(lines):
    if not(int(j.split()[2]) == temp_i):
        if first:
            offset = i
            first = False
        ratio_out1.append(int(j.split()[0]))
        comprsser_out.append(int(j.split()[1]))
        comprsser_count.append(int(j.split()[2]))  
        #print(temp_i,int(j.split()[2]),int(j.split()[1]))
        temp_i = comprsser_count[-1]
        plot_count.append(i-offset)
f.close()



#print(X.shape,S.shape,I.shape)
plt.figure()
#plt.plot(y,'o',label='originial data')
#plt.plot(I,X,'+',label='reconstructeda')
# plt.plot(comprsser_out[14:], '-', label='vhdl compressor output')# for j=2
##plt.plot(comprsser_out[26:], '-', label='vhdl compressor output') for j=3
plt.plot(plot_count,np.divide(comprsser_out,np.power(2,ratio_out1)), '-', label='vhdl compressor output')# for j=2
plt.scatter(Ix,X,c="black",marker='+',label='python comprssor output')
plt.xlabel('x')
plt.ylabel('y')
plt.title('test data from vhdl file')
plt.legend()
plt.figure()
plt.plot(Ix,J,'o-',label='ratio')#figure 2
#plt.plot(ratio_out1[25:], 'x--',label=("vhdl simulation")) for j=3
plt.plot(plot_count,ratio_out1, 'x--',label=("vhdl simulation"))# for j=2
#plt.gca().axes.xaxis.set_ticks([50,100,250,500,1000,2500, 5000])
plt.legend()
plt.figure()
plt.plot(sub_2,'x--',label=("2 data subtract"))


plt.gca().axes.xaxis.set_ticklabels([0,100,200,300,400,500,600,700,800,900,1000])
plt.gca().get_xaxis().set_tick_params(which='minor', size=0)
plt.gca().get_xaxis().set_tick_params(which='minor', width=0) 
plt.gca().get_xaxis().set_major_formatter(matplotlib.ticker.ScalarFormatter())
plt.gca().ticklabel_format(style='plain',axis='x',useOffset=False)
plt.legend()
plt.figure()
plt.plot(I,S,label='std')#rfigure 3

plt.show()
