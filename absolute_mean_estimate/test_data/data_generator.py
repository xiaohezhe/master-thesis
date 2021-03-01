import numpy as np
import matplotlib.pyplot as plt




# k=2
# m=13500
# x=np.arange(1000).astype(np.)
# rn=np.random.default_rng()

# noise = rn.normal(0,(2),(x.shape))##2*8*.08=12.8, the data is around 10 
# noise2 = rn.normal(0,(3000),(x.shape)-900)## the middle part data sigma=3000,100 data
# y= (k)*x + (m) + noise
# y[500:600] += noise2

# plt.figure()
# plt.plot(x,y)
# plt.show()

# np.savetxt('data.csv',y.astype(),fmt='%i',delimiter=',')


k=0
m=13500
x=np.arange(1000)
rn=np.random.default_rng()
xshape = np.array(x.shape)
noise = rn.normal(0,(2),xshape)##2*8*.08=12.8, the data is around 10 
noise2 = rn.normal(0,(100),xshape-990)## the middle part data sigma=3000,100 data
noise3 = rn.normal(0,(200),xshape-990)
noise6 = rn.normal(0,(500),xshape-950)
noise4 = rn.normal(0,(3000),xshape-999)
noise5 = rn.normal(0,(10),xshape-900)
y= k*x +(m)

#y= k*x + (m) + noise#y move up 13500(b) y=kx+b
y[700:701] += noise4.astype(y.dtype)#sigma=3000
#y[400:410] += noise3.astype(y.dtype)#sigma=200
#y[300:310] += noise2.astype(y.dtype)#sigma=100
#y[100:200] += noise5.astype(y.dtype)#sigma=10
#y[500:550] += noise6.astype(y.dtype)#sigma=500
plt.figure()
plt.plot(x,y)
print(y[500:510])
np.savetxt('data.csv',y,fmt='%i',delimiter=',')


noise_test = np.abs(rn.normal(0,(10),200))
noise_test2 = np.abs(rn.normal(0,(100),100))
noise_test[100:] += noise_test2

out_mov_avg = []
out_iir_filter = [noise_test[0]]

for i in range(200-8):
    out_mov_avg.append(np.mean(noise_test[i:8+i]))
for i in range(200-1):
    out_iir_filter.append(out_iir_filter[i-1]*7/8 + noise_test[i]/8)
plt.figure()
plt.plot(noise_test,label="background subtraction")
plt.plot(np.arange(3.5,200-4.5),out_mov_avg, label="moving average, group size=8")
plt.plot(np.arange(0,200),out_iir_filter, label="low-pass filter, speed is 3")
plt.xlabel("sampling data")
plt.ylabel("magnitude")
plt.legend()
plt.show()