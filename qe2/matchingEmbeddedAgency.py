# Using reinforcement learning to a game of repeated matching
# Modified from a version obtained from Phanish Puranam

import random
import numpy as np
import csv 
    
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
