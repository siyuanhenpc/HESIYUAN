import os

nSimus = 20

for i in range(nSimus):
    print("###################### SIMU NO. ", i)
    os.system("Zrun simu_"+str(i)+".inp")
