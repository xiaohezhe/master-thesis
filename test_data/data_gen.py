import numpy as np
import matplotlib.pyplot as plt




k=25
m=1000
x=np.arange(100).astype(np.int16)
rn=np.random.default_rng()
sigma = 1
noise = rn.normal(0,np.int16(100),np.int16(x.shape))
y= np.int16(k)*x + np.int16(m) + noise

plt.figure()
plt.plot(x,y)
plt.show()

np.savetxt('data.csv',y.astype(np.int16),fmt='%i',delimiter=',')