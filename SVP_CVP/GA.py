import numpy as np


def ga(base):

    B1 = np.linalg.norm(base[0])**2
    m = np.dot(base[0], base[1]) / B1
    base[1] = base[1] - np.multiply(np.round(m), base[0])
    B2 = np.linalg.norm(base[1])**2

    while np.linalg.norm(base[1]) < np.linalg.norm(base[0]):
        base[0], base[1] = base[1], base[0]
        B1 = B2
        m = np.dot(base[0], base[1]) / B1
        base[1] = base[1] - np.multiply(np.round(m), base[0])
        B2 = np.linalg.norm(base[1]) ** 2

    return base


#Base = np.array([[2.0, 1.0], [3.0, -1.0]])
#print(ga(Base))