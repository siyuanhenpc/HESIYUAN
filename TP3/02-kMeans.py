import numpy as np
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
import matplotlib.cm as cm

nClusters = 5
colors = ['#0000FF', '#008000', '#FF0000', '#FFA500', '#000080', '#FFD700', '#008B8B', '#32CD32', '#808080', '#F08080', '#8B4513', '#00FFFF', '#9400D3', '#FF1493','#DAA520', '#808000']

C      = np.load("temperatureFields_2PC.npy")

### A COMPLETER, cf documentation de sklearn.cluster.KMeans
### Construire le vecteur 'labels' tel que labels[i] = numero du cluster contenant le i-eme champ de temperature.

kmeans = KMeans(n_clusters = nClusters)
labels = kmeans.fit_predict(C)

plt.figure()
plt.xlabel("C1")
plt.ylabel("C2")
### A COMPLETER (visualisation des clusters en 2D)
plt.show()
