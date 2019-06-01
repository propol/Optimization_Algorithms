#Gram - Schmidt Orthogonalization
import numpy as np


def gso_coefficient(b1, b2):
    return np.dot(b2, b1) / np.dot(b1, b1)


def multiply(coefficient, b):
    return list(map((lambda x: x * coefficient), b))


def proj(b1, b2):
    return np.multiply(gso_coefficient(b1, b2), b1)


def gso(X):
    Y = []
    for i in range(len(X)):
        temp_vec = X[i]
        for inY in Y :
            proj_vec = proj(inY, X[i])
            temp_vec = list(map(lambda x, y: x - y, temp_vec, proj_vec))
        Y.append(temp_vec)
    return Y


Base = np.array([[2.0, 1.0], [3.0, -1.0]])
print(np.array(gso(Base)))
