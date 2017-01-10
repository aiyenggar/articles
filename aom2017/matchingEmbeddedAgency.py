# Using reinforcement learning to a game of repeated matching
# Modified from a version obtained from Phanish Puranam

import random
import numpy as np
import csv 

def choice(attraction,t):
    retval=random.random() # this picks a random number between 0 and 1
    if attraction[t]>retval: # compare to the agent's prior
        retval= 0
    else:
        retval= 1
    return retval

def learning(phi):
    if (phi < 0 or phi > 1):
        return "LearnUndef"
    if phi <= 0.05:
        return "Slow"
    if phi <= 0.3:
        return "Medium"
    if phi <= 0.7:
        return "Fast"
    return "Rapid"
    
def position(p):
    if (p < 0 or p > 1):
        return "PositionUndef"
    if p <= 0.10:
        return "L"
    if p <= 0.35:
        return "LC"
    if p <= 0.65:
        return "C"
    if p < 0.9:
        return "RC"
    return "R"
    
num_periods=100 #number of periods to simulate the model
num_pairs=1000 #number of pairs of agents

pAs=[0.5, 0.75, 0.95]
pBs=[0.05, 0.5, 0.95]
phiAs=[0.05, 0.3]
phiBs=[0.05, 0.3, 0.7]
models = []
for pB in pBs:
    for phiB in phiBs:
        for pA in pAs:
            for phiA in phiAs:
                modelName="F["+position(pA)+"-"+learning(phiA)+"] U["+position(pB)+"-"+learning(phiB)+"]"
                models.append([modelName, pA, phiA, pB, phiB])

allResults = np.zeros((num_periods,len(models)))
iteration = 0
for current in models:
    phi1 = current[2]
    phi2 = current[4]
    prefA=np.zeros((num_periods+1,1))
    prefB=np.zeros((num_periods+1,1))
    prefA[0] = current[1]
    prefB[0] = current[3]

    org_perf=np.zeros((num_periods,num_pairs)) # fill zeors for all time
    org_cumperf=np.zeros((num_periods,num_pairs)) # cumulative performance over time for each pair of agents
    result=np.zeros((num_periods,3)) # this stores the aggregated results which we will show on graphs
           
    #mapoff matrix
    R=np.zeros((2,2)) # 2 by 2 matrix full of zeroes
    R[0][0]=1 # Payoff = 1 when both agents chose 0
    R[1][1]=1 # Payoff = 1 when both agents chose 1
    
    
    for a in range(num_pairs): # for each pair of agent
       
        for t in range(num_periods): # for each period
            choice1=choice(prefA,t) # agent 1 choice at t
            choice2=choice(prefB,t) # agent 2 choice at t
            payoff=R[choice1][choice2] 
            
            org_perf[t][a]=payoff # this payoff constitutes the org's performance at time t...
            # ... and contributes to the org's cumulative performance:
            if t>0: 
                org_cumperf[t][a]=org_cumperf[t-1][a]+payoff
            else:
                org_cumperf[t][a]=payoff
            
            # The 2 agents update their priors based on what the payoff was
            if payoff==1:
                if choice1==0:
                    prefA[t+1]=prefA[t]+phi1*(1-prefA[t])
                else:
                    prefA[t+1]=prefA[t]-phi1*prefA[t]
                if choice2==0:
                    prefB[t+1]=prefB[t]+phi2*(1-prefB[t])
                else:
                    prefB[t+1]=prefB[t]-phi2*prefB[t] 
            if payoff==0:
                if choice1==0:
                    prefA[t+1]=prefA[t]-phi1*prefA[t]
                else:
                    prefA[t+1]=prefA[t]+phi1*(1-prefA[t])
                if choice2==0:
                    prefB[t+1]=prefB[t]-phi2*prefB[t]
                else:
                    prefB[t+1]=prefB[t]+phi2*(1-prefB[t])

    
    for t in range(num_periods):
        result[t][0]=t+1
        result[t][1]=float(np.sum(org_perf[t,:]))/num_pairs
        result[t][2]=float(np.sum(org_cumperf[t,:]))/num_pairs
        allResults[t][iteration] = result[t][1]
    
    iteration += 1

results = open('embeddedAgency.csv', 'w')
writer = csv.writer(results)
header = []
header.append('period')
for model in models:
    header.append(model[0])
writer.writerow(header) 
iteration=1
for values in allResults:
    row = [iteration]
    row.extend(values)
    writer.writerow(row)
    iteration += 1
results.close()  
