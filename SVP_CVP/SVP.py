import numpy as np
import sympy as sym

a = np.array([2, 1])
b = np.array([3, 2])

m = sym.Symbol('m')
l = sym.Symbol('l')

L = m*a + l*b
print("Vectors belonging in the grid have the following form: L =", L)
print("(Brute Force) Starting calculations to solve the SVP for L...")
print("")

m, l = -10, -10
shortest_vector = np.array([100, 100])
shortest_m, shortest_l = 100, 100
while m <= 10:
    while l <= 10:
        L = m*a + l*b
        if m == 0 and l == 0:
            l += 1
            continue
        elif np.linalg.norm(L) < np.linalg.norm(shortest_vector):
            shortest_vector = L
            shortest_m, shortest_l = m, l
        l += 1
    l = -10
    m += 1

print("m = ", shortest_m, "l = ", shortest_l, "vector = ", shortest_vector)
print("The shortest vector norm of the grid is: ", np.linalg.norm(shortest_vector))


