import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from scipy import stats

refDatFileName  = 'postprocessing_'
nSimus          = 20
nPoints         = 100
damageLowerZone = []
damageUpperZone = []

for i in range(nSimus):
    datFile = refDatFileName + str(i) + '.dat'
    with open(datFile, 'r') as f:
        lines = f.readlines()
    lastLine=lines[-1].split()[1:]
    damLowerZone = np.array([float(lastLine[i]) for i in range(int(len(lastLine)/2))])
    damUpperZone = np.array([float(lastLine[i]) for i in range(int(len(lastLine)/2),len(lastLine))])
    damageLowerZone.append(damLowerZone.mean())
    damageUpperZone.append(damUpperZone.mean())

##############
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
###############

damageLowerZone = np.array(damageLowerZone)
damageUpperZone = np.array(damageUpperZone)
ratio           = damageUpperZone/damageLowerZone

maxDamage       = np.max([damageLowerZone.max(), damageUpperZone.max()])

print("Lower zone:")
print("    Mean: ", 100*damageLowerZone.mean(), "%")
print("    Standard deviation: ", 100*damageLowerZone.std(), "%")
print("Upper zone:")
print("    Mean: ", 100*damageUpperZone.mean(), "%")
print("    Standard deviation: ", 100*damageUpperZone.std(), "%")
print("Ratio upper zone / lower zone:")
print("    Mean: ", ratio.mean())
print("    Standard deviation: ", ratio.std())


# Estimation des densites de probabilite des dommages (zones inferieure et superieure)
args         = maxDamage*np.linspace(0., 1., num = nPoints)
kernelLow    = stats.gaussian_kde(damageLowerZone)
kernelUp     = stats.gaussian_kde(damageUpperZone)
args2        = ratio.max()*np.linspace(0., 1., num = nPoints)
kernelRatio  = stats.gaussian_kde(ratio)
listOfCurves = [(args,kernelLow(args)), (args,kernelUp(args))]
PlotCurves(listOfCurves, listOfColors=['r','b'], markers=[None, None], labels=['Lower zone', 'Upper zone'], legendPosition = 'upper right', xylabels = ('accumulated plastic strain','density'), linestyles = ['-','-'], savefig = True, nameFig = 'damage_kernels.png', show = True)
listOfCurves = [(args2,kernelRatio(args2))]
PlotCurves(listOfCurves, listOfColors=['r'], markers=[None], labels=None, legendPosition = 'upper right', xylabels = ('ratio damage upper zone / lower zone','density'), linestyles = ['-'], savefig = True, nameFig = 'damage_ratio_kernel.png', show = True)




