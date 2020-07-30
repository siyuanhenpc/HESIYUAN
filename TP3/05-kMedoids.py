import numpy as np
import matplotlib.pyplot as plt

numberOfClusters = 5
distMatrixFile   = "distMatrix_Grassmann_light.npy" # "distMatrix_temperature_light.npy"
MDSfile          = "MDS_Grassmann.npy"        # "MDS_temperature.npy"
lightVersion     = True

def InitializeMedoids(distanceMatrix, nClusters):
    a       = np.sum(distanceMatrix, axis=1)
    b       = np.transpose(np.transpose(distanceMatrix)/a)
    v       = np.sum(b, axis=0)
    medoids = np.sort(np.argsort(v)[:nClusters])    # array of indices
    return medoids

def KMedoids(distanceMatrix, nClusters, nIter=100):
    medoids        = InitializeMedoids(distanceMatrix, nClusters) #np.random.choice(distanceMatrix.shape[0],nClusters)
    medoidsNew     = np.copy(medoids)
    clusters       = {}
    distanceMatrix = distanceMatrix*distanceMatrix
    for i in range(nIter):
        clusterAssignments = np.argmin(distanceMatrix[:,medoids], axis=1)
        for k in range(nClusters):
            clusters[k] = np.where(clusterAssignments==k)[0]
        for k in range(nClusters):
            clusterMembers1,clusterMembers2 = np.meshgrid(clusters[k],clusters[k])
            intraClusterDistances = np.mean(distanceMatrix[clusterMembers1,clusterMembers2],axis=1)
            medoidId = np.argmin(intraClusterDistances)
            medoidsNew[k] = clusters[k][medoidId]
        np.sort(medoidsNew)
        if np.array_equal(medoids, medoidsNew):
            print("The algorithm converged after ", i+1, " iterations.")
            break
        medoids = np.copy(medoidsNew)
    else:
        clusterAssignments = np.argmin(distanceMatrix[:,medoids], axis=1)
        for k in range(nClusters):
            clusters[k] = np.where(clusterAssignments==k)[0]
        print("The algorithm did not converge after ", i, " iterations.")
    return medoids, clusters

def LabelsVector(clusters):
    '''
    Input:
    clusters: dictionary. clusters[k] is an array containing the indices of points belonging to cluster k.

    Output:
    labels: 1D array of integers. labels[j] = k if example j belongs to cluster k.
    '''
    nClusters = len(clusters)
    nExamples = 0
    for i in range(nClusters):
        nExamples += len(clusters[i])
    labels = np.zeros(nExamples)
    for i in range(nClusters):
        nMembers = len(clusters[i])
        for j in range(nMembers):
            labels[clusters[i][j]] = i
    return labels.astype(int)

#########################################################################

distanceMatrix = np.load(distMatrixFile)
if lightVersion:
    dataset = np.load(MDSfile)[:1000]
else:
    dataset = np.load(MDSfile)

medoids, clusters = KMedoids(distanceMatrix, numberOfClusters, nIter=100)
labels            = LabelsVector(clusters)

plt.figure()
colors = np.array(['#0000FF', '#008000', '#FF0000', '#FFA500', '#000080', '#FFD700', '#008B8B', '#32CD32', '#808080', '#F08080', '#8B4513', '#00FFFF', '#9400D3', '#FF1493','#DAA520', '#808000'])
plt.scatter(dataset[:,0], dataset[:,1], marker='o', s=30, color=colors[labels])
plt.scatter(dataset[medoids,0], dataset[medoids,1], c = 'white', marker = 'o', s=50, edgecolor = 'black')
plt.xticks(())
plt.yticks(())
plt.show()

