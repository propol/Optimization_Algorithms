#Calculates the Gaussian Heuristic of a lattice L
import numpy as np
from math import gamma
from math import pi


def GH(L):

    n = len(L)
    gh = ((np.linalg.det(L) * gamma(n/2 + 1))**1/n) / pi**1/2

    return gh


base = np.array([[2.0, 1.0], [3.0, -1.0]])
print(GH(base))
