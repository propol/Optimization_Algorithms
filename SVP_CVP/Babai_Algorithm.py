import numpy as np
import GA
from GSO import gso


# Babai's algorithm for lattices with a base of 2D vectors
def babai_2D(base):

    B = GA.ga(base)
    B_star = gso(B)

    t = np.array([1,0])
    b = t

    j = len(base)
    while j >= 1:
        c = np.round(np.dot(b, B_star[j-1]) / np.dot(B_star[j-1], B_star[j-1]))
        b = b - np.dot(c, B[j-1])

        j-=1

    return t - b


# Babai's algorithm for 2D lattices without the use of the Gaussian Algorithm
def babai_2D_noGA(base):

    B = base
    B_star = gso(B)

    t = np.array([1,0])
    b = t

    j = len(base)
    while j >= 1:
        c = np.round(np.dot(b, B_star[j-1]) / np.dot(B_star[j-1], B_star[j-1]))
        b = b - np.dot(c, B[j-1])

        j-=1

    return t - b

#Base = np.array([[2.0, 1.0], [3.0, -1.0]])
#print(babai_2D(Base))
#print(babai_2D_noGA(Base))
