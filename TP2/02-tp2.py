import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from scipy.stats import t # Student
from scipy.stats import f # Fisher

dim           = 2  # = 2 or 150
nDimsForModel = dim

# Donnees
Xfull = np.load('dim'+str(dim)+'_temperature.npy')  # array of shape (nsamples, nfeatures=dim)
yfull = np.load('dim'+str(dim)+'_damage.npy')       # array of shape nsamples

# Reduction du nombre de modes pris en compte
Xfull = Xfull[:,:nDimsForModel]

# Ensembles d'entrainement et de test
X, Xtest, y, ytest = train_test_split(Xfull, yfull, test_size=0.2)
nsamples  = X.shape[0]
nfeatures = X.shape[1]
p         = nfeatures+1
print("Number of training samples: ", nsamples)
print("Number of features: ", nfeatures)
print("Number of test samples: ", Xtest.shape[0])

# Regression lineaire par la methode des MCO
lr = LinearRegression()
lr.fit(X,y)
params = np.append(lr.intercept_,lr.coef_)
ypred  = lr.predict(X)

# ANOVA (analyse de la variance)
sct = np.sum((y-y.mean())**2)
sce = np.sum((ypred-y.mean())**2)
scr = np.sum((y-ypred)**2)

# Residus
residuals = y-ypred

# Coefficient de determination
r2         = sce/sct  # = lr.score(X, y)
adjustedR2 = 1 - (1-r2)*nsamples/(nsamples-p)

# Ecarts types des estimateurs MCO
matX     = np.append(np.ones((nsamples,1)), X, axis=1)
resVar   = (sum((y-ypred)**2))/(nsamples-p) # estimateur sans biais de la variance de l'erreur du modele
paramVar = resVar*(np.linalg.inv(np.dot(matX.T,matX)).diagonal()) # variances des estimateurs MCO
paramStd = np.sqrt(paramVar)

# Test de significativite globale du modele
fStat   = (nsamples-p)*sce / ((p-1)*scr) # statistique de test
pValueF = 1. - f.cdf(fStat,p-1,nsamples-p)

# Tests de significativite des variables explicatives
tStats  = params/paramStd   # statistiques de test
pValues =[2.*(1.- t.cdf(np.abs(tt),(nsamples - p))) for tt in tStats]
pValues = np.asarray(pValues)

# Evaluation du modele sur l'ensemble de test
ytestPred  = lr.predict(Xtest)
rmse       = np.sqrt(np.mean((ytest - ytestPred)**2))
normRef    = np.sqrt(np.mean(ytest**2))
mape       = (np.abs(ytest - ytestPred)/np.abs(ytest)).mean()

# Recap
print("Residuals:")
print("Min   Q1   Median   Q3   Max")
print(residuals.min(), np.quantile(residuals,0.25), np.median(residuals), np.quantile(residuals,0.75), residuals.max())
print(" ")
print("Coefficients")
print("(Param 0 = intercept, Param i for mode i when i>0")
print("Params   *   Values   *   Std. errors   *   t values   *   p-values")
for i in range(len(params)):
    print("Param ", i, "   ", params[i], "   ", paramStd[i], "   ", tStats[i], "   ",  pValues[i])
print(" ")
print("F-statistic: ", fStat, "  ;  p-value: ", pValueF)
print("R-squared: ", r2)
print("Adjusted R-squared: ", adjustedR2)
print(" ")
print("RMSE (root mean square error, damage units): ", rmse, "   (reference: ", normRef, ")")
print("MAPE (mean average percentage error): ", mape*100, "%")

