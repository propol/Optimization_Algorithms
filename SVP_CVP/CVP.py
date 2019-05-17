import numpy as np
import sympy as sym

a = np.array([2, 1])
b = np.array([3, 2])
c = np.array([5.5, 0.8])

m = sym.Symbol('m')
l = sym.Symbol('l')

L = m*a + l*b
print("Vector c =", c, " does not belong in the grid L =", L, "(m and l belong to Z)")
print("(Brute Force) Starting calculations to solve the CVP for L and c...")
print("")

m, l = -10, -10
closest_vector = np.array([100, 100])
closest_m, closest_l = 100, 100
while m <= 10:
    while l <= 10:
        L = m*a + l*b
        if np.linalg.norm(c - L) < np.linalg.norm(c - closest_vector):
            closest_vector, closest_m, closest_l = L, m, l
        l += 1
    l = -10
    m += 1

print("m = ", closest_m, "l = ", closest_l, "closest vector = ", closest_vector)
print("The smallest distance to c is: ", np.linalg.norm(c - closest_vector))