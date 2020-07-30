import numpy as np
import scipy.linalg as spl
import matplotlib.pyplot as plt

#####################
# Processus gaussien
#####################

class GaussianProcess:

    def __init__(self, meanFct = None, covFct = None, times = None):
        self.meanFct = meanFct
        self.covFct  = covFct
        self.times   = times
        self.X       = None
        self.Xlight  = None  

    def SetMeanFct(self, meanFct):
        self.meanFct = meanFct

    def SetCovFct(self, covFct):
        self.covFct = covFct

    def SetTimes(self, times):
        self.times = times

    def GetMeanVector(self):
        return self.meanFct(self.times)

    def GetCovMatrix(self):
        ### A COMPLETER. Output = matrice de covariance. Utiliser la fonction de covariance self.covFct.

    def GetRealizations(self, nRealizations = 1, plot = True):
        '''
        Renvoie une realisation (ou "trajectoire" ou "tirage") du processus gaussien.
        '''
        meanVect = self.GetMeanVector()
        covMat   = self.GetCovMatrix()
        matA     = GetModes(covMat)

        ### A COMPLETER:
        ### Utiliser la commande np.random.multivariate_normal pour creer
        ### une matrice y (nombre de lignes = len(self.times), nombre de colonnes = nRealizations)
        ### dont les colonnes sont les realisations d'un vecteur gaussien d'esperance nulle et de
        ### matrice de covariance egale a l'identite.

        ### A COMPLETER:
        ### Construire la matrice m dont les colonnes sont les realisations du vecteur aleatoire X. 

        mu = np.transpose(np.tile(meanVect, (nRealizations, 1)))               # duplication du vecteur moyenne pour avoir
                                                                               # nRealizations colonnes identiques
        self.X = mu + m  # len(self.times) lignes, nRealizations colonnes
        if plot :
            for i in range(nRealizations):
                listOfCurves = [(times, meanVect), (times, self.X[:,i])]
                PlotCurves(listOfCurves, listOfColors=['b','r'], markers=[None,None], labels=['Mean', 'Gaussian process'], legendPosition = 'upper right', xylabels = ('time','loading'), linestyles = ['-','-'])
        return self.X, self.times

    def Subsampling(self, step, plot = True):
        '''
        Sous-echantillonne les trajectoires du processus gaussien.
        '''
        maxi = int((self.X.shape[0]-1)/step)
        self.Xlight = np.asarray([self.X[k*step,:] for k in range(maxi+1)])
        tLight      = np.asarray([self.times[k*step] for k in range(maxi+1)])
        meanVect = self.GetMeanVector()
        if plot :
            for i in range(nRealizations):
                listOfCurves = [(times, meanVect), (times, self.X[:,i]), (tLight,self.Xlight[:,i])]
                PlotCurves(listOfCurves, listOfColors=['b','r','g'], markers=[None,None,'x'], labels=['Mean', 'Gaussian process', 'Sampling'], legendPosition = 'upper right', xylabels = ('time','loading'), linestyles = ['-','-','--'])
        return self.Xlight, tLight


########################
# Fonctions auxiliaires
########################

def GetModes(covMat):
    ### A COMPLETER
    ### Note: a cause des erreurs numeriques, certaines valeurs propres tres faibles
    ###       peuvent etre negatives, ce qui genere un message d'erreur au moment de calculer
    ###       leur racines carrees --> remplacer les valeurs negatives par 0.

def WriteTable(inpFile, times, values, outFile, datFile):
    with open(inpFile,'r') as f:
        lines = f.readlines()
    for l in range(len(lines)): 
        if lines[l].startswith('***table'): 
            lTimes  = l+3
            lValues = l+5
        if lines[l].startswith('***resolution'): 
            lSequences = l+1  
            lTimesRes  = l+4
            lInc       = l+6
        if lines[l].startswith('**test'): 
            lTest = l
    lines[lSequences] = '**sequence '+ str(len(times)) +'\n'
    lines[lTimesRes]  = ''.join(str(t)+' ' for t in times) +'\n'
    lines[lInc]       = ''.join('1 ' for t in range(len(times)-1)) +'\n'
    lines[lTimes]     = ''.join(str(t)+' ' for t in times) +'\n'
    lines[lValues]    = ''.join(str(v)+' ' for v in values)+'\n' 
    lines[lTest]      = '**test '+datFile+'\n' 
    with open(outFile,'w') as f:
        f.writelines(lines)

def PlotCurves(listOfCurves, listOfColors=['r','b','g','k'], markers=['.','o','*','v'], labels=None, legendPosition = 'upper right', xylabels = None, linestyles = ['-','-','-','-'], savefig = False, nameFig = 'fig.png', show = True):
    fig, ax    = plt.subplots()
    for i in range(len(listOfCurves)):
        x,y = listOfCurves[i]
        if labels is not None:
            ax.plot(x, y,listOfColors[i],label=labels[i],marker=markers[i], linestyle = linestyles[i])
            ax.legend(loc=legendPosition)
        else:
            ax.plot(x, y,listOfColors[i])
    if xylabels is not None :
        xlab, ylab = xylabels
        plt.xlabel(xlab)
        plt.ylabel(ylab)
    if savefig:
        plt.savefig(nameFig)
    if show:
        plt.show()
    else:
        plt.close()


#################################
#Fonctions moyenne et covariance
#################################

def myMeanFct(params):
    def f(t):
        return params[0]*np.sin(params[1]*t)
    return f

def myCovFct(params):
    def f(t1, t2):
        ### A COMPLETER
    return f


##############
# Application
##############

amplitude     = 1.              # semi-amplitude de la fonction moyenne
puissance     = 1.              # puissance intervenant dans la fonction de covariance, doit etre dans ]0.; 2.]
nTimes        = 100             # nb de pas de temps pour visualisation
step          = 5               # facteur de sous-echantillonnage
t0            = 0.02            # temps caracteristique (pour la fonction de covariance)
variance      = 0.005           # facteur multiplicatif dans fonction de covariance
nRealizations = 20              # nb de realisations/trajectoires du processus gaussien a generer. 
refFile       = "simu"          # nom du fichier input reference, sans '.inp'

meanFct   = myMeanFct([amplitude,2.*np.pi])
covFct    = myCovFct([variance,t0,puissance])
times     = np.arange(0.,1.+1./nTimes, 1./nTimes)
gp        = GaussianProcess(meanFct, covFct, times)
X, t1     = gp.GetRealizations(nRealizations, plot=False)
Xlight,t2 = gp.Subsampling(step, plot = False)

# Operations sur la sequence temporelle pour definir le chargement
tt1       = (0.1 + t1*0.9/t1.max()).tolist()
timesNew1 = [0.]+tt1
tt2       = (0.1 + t2*0.9/t2.max()).tolist()
timesNew2 = [0.]+tt2
tTemp     = [0., 0.1, 1.]
temp      = [0., 1., 1.]


for i in range(nRealizations):
    # Conditions aux limites: chargement 0. aux temps 0. et 0.1
    mean   = [0., 0.] + gp.GetMeanVector()[1:].tolist()
    XX     = [0., 0.] + X[1:,i].tolist()
    values = [0., 0.] + Xlight[1:,i].tolist()
    # Courbes:
    listOfCurves = [(timesNew1, mean), (timesNew1, XX), (timesNew2, values), (tTemp, temp)]
    PlotCurves(listOfCurves, listOfColors=['b','r','g', 'k'], markers=[None,None,'x', None], labels=['Mean', 'Gaussian process', 'Sampling', 'Thermal loading factor'], legendPosition = 'lower left', xylabels = ('time','loading'), linestyles = ['-','-','--', '--'], savefig = True, nameFig = 'fig'+str(i)+'.png', show = True)
    # Ecriture du fichier input pour les calculs sur Zset
    WriteTable(refFile+".inp", timesNew2, values, refFile+"_"+str(i)+".inp", "postprocessing_"+str(i)+".dat")



