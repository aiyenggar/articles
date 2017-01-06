import random
import numpy as np
import matplotlib.pyplot as plt
import csv # for excel output

#CHOICE PROCESS
def choose(attraction,t):
    roulette=random.random() # this picks a random number between 0 and 1
    #print roulette
    if attraction[t]>roulette: # choices are made by comparing the random number to the agent's prior
        choice= 0
    else:
        choice= 1
    return choice

def t_by_t_plot(x, y, title, axe, fontsize=12):
    '''
    Plots period by period
    '''
    axe.plot(x, y, color='red')
    ymin = np.min(y)
    ymax = np.max(y)
    axe.set(ylim=(ymin - 0.05*(ymax-ymin), ymax + 0.05*(ymax-ymin)))
    axe.set_xlabel('t', fontsize=fontsize)
    axe.set_title(title, fontsize=fontsize, fontweight="bold")    

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
    
#SIMULATION PARAMETERS
T=100 #number of periods to simulate the model
NP=1000 #number of pairs of agents
#AGENT'S BELIEFS

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

allResults = np.zeros((T,len(models)))
iteration = 0
for current in models:
    phi1 = current[2]
    phi2 = current[4]
    attA=np.zeros((T+1,1))
    attB=np.zeros((T+1,1))
    attA[0] = current[1]
    attB[0] = current[3]
    
    
    #DEFINING RESULTS VECTORS (FOR STORAGE)
    # we will produce per agent, one vector of length T and breadth=2 that reports average across NP pairs of agents per period and cumulative performance  
    org_perf=np.zeros((T,NP)) # performance over time for each pair of agents (starts full of zeroes, and will be filled over time as the model runs)
    org_cumperf=np.zeros((T,NP)) # cumulative performance over time for each pair of agents
    result=np.zeros((T,3)) # this stores the aggregated results which we will show on graphs
           
    #DEFINING PAYOFF SURFACE (MATCHING GAME)
    R=np.zeros((2,2)) # 2 by 2 matrix full of zeroes
    R[0][0]=1 # Payoff = 1 when both agents chose 0
    R[1][1]=1 # Payoff = 1 when both agents chose 1
    
    
    for a in range(NP): # for each pair of agent
       
        for t in range(T): # for each period
            choice1=choose(attA,t) # agent 1 makes a choice for period t
            choice2=choose(attB,t) # agent 2 makes a choice for period t
            payoff=R[choice1][choice2] # the pair gets a payoff for these choices
            
            org_perf[t][a]=payoff # this payoff constitutes the org's performance at time t...
            # ... and contributes to the org's cumulative performance:
            if t>0: 
                org_cumperf[t][a]=org_cumperf[t-1][a]+payoff
            else:
                org_cumperf[t][a]=payoff
            
            # The 2 agents update their priors based on what the payoff was
            if payoff==1:
                if choice1==0:
                    attA[t+1]=attA[t]+phi1*(1-attA[t])
                else:
                    attA[t+1]=attA[t]-phi1*attA[t]
                if choice2==0:
                    attB[t+1]=attB[t]+phi2*(1-attB[t])
                else:
                    attB[t+1]=attB[t]-phi2*attB[t] 
            if payoff==0:
                if choice1==0:
                    attA[t+1]=attA[t]-phi1*attA[t]
                else:
                    attA[t+1]=attA[t]+phi1*(1-attA[t])
                if choice2==0:
                    attB[t+1]=attB[t]-phi2*attB[t]
                else:
                    attB[t+1]=attB[t]+phi2*(1-attB[t])
              
              
    #PRODUCE RESULTS
    
    for t in range(T):
        result[t][0]=t+1
        result[t][1]=float(np.sum(org_perf[t,:]))/NP
        result[t][2]=float(np.sum(org_cumperf[t,:]))/NP
        allResults[t][iteration] = result[t][1]
        
    
#    plt.style.use('ggplot') # Setting the plotting style
#    
#    fig = plt.figure(figsize=(8.27, 11.69), dpi=100)
#    ax1 = plt.subplot2grid((6,5),(0,1), colspan = 3)
#    t_by_t_plot([x[0] for x in result], [x[1] for x in result], "Performance", ax1, fontsize=12)
#    
#    fig = plt.figure(figsize=(8.27, 11.69), dpi=100)
#    ax1 = plt.subplot2grid((6,5),(0,1), colspan = 3)
#    t_by_t_plot([x[0] for x in result], [x[2] for x in result], "Cumulative Performance", ax1, fontsize=12)
    
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