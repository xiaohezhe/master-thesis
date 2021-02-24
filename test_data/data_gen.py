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
noise4 = rn.normal(0,(3000),xshape-996)
noise5 = rn.normal(0,(10),xshape-900)
y= k*x +(m)

#y= k*x + (m) + noise#y move up 13500(b) y=kx+b
y[500:504] += noise4.astype(y.dtype)
# y[700:710] += noise3
# y[800:810] += noise4
# y[300:400] += noise5
# y[150:200] += noise6
plt.figure()
plt.plot(x,y)
plt.show()
print(y[500:510])
np.savetxt('data.csv',y,fmt='%i',delimiter=',')
