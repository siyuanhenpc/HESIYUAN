import numpy as np
from sklearn.linear_model import LinearRegression

dim           = 2  # = 2 or 150
nDimsForModel = dim

# Donnees
Xfull = np.load('dim'+str(dim)+'_temperature.npy')  # array of shape (nsamples, nfeatures=dim)
yfull = np.load('dim'+str(dim)+'_damage.npy')       # array of shape nsamples

# Reduction du nombre de modes pris en compte
Xfull = Xfull[:,:nDimsForModel]



