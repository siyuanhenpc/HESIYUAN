import numpy as np
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

nPC = 2 # nombre de composantes principales que l'on garde

Xc = np.load("temperatureFields.npy")

### A COMPLETER, cf documentation de sklearn.decomposition.PCA .
### Calculer la matrice C dont les lignes sont les projections des champs de temperature sur les deux premiers axes principaux.

plt.figure()
plt.title("Deux premieres composantes principales")
plt.xlabel("C1")
plt.ylabel("C2")
plt.scatter(C[:,0],C[:,1], c = 'b', marker = 'o', s=30)
plt.show()

np.save("temperatureFields_"+str(nPC)+"PC.npy", C)
