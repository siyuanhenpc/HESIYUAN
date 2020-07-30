import numpy as np
import matplotlib.pyplot as plt

tempMDS      = np.load("MDS_temperature.npy")
grassmannMDS = np.load("MDS_Grassmann.npy")

plt.figure()
plt.title("MDS plot (from euclidean distances between T fields)")
plt.scatter(tempMDS[:,0],tempMDS[:,1], c = 'b', marker = 'o', s=30)
plt.show()

plt.figure()
plt.title("MDS plot (from Grassmann distances)")
plt.scatter(grassmannMDS[:,0],grassmannMDS[:,1], c = 'b', marker = 'o', s=30)
plt.show()
