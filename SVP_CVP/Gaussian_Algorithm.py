import numpy as np

b1 = np.array([2, 1])
b2 = np.array([3, 2])

print("(Gauss - Lagrange) Initializing algorithm to solve the SVP for L...")
print("")

B1 = np.linalg.norm(b1)**2
m = (b1[0]*b2[0] + b1[1]*b2[1]) / B1
b2 = b2 - np.multiply(np.round(m), b1)
B2 = np.linalg.norm(b2)**2

while np.linalg.norm(b2) < np.linalg.norm(b1):
    b1, b2 = b2, b1
    B1 = B2
    m = (b1[0]*b2[0] + b1[1]*b2[1]) / B1
    b2 = b2 - np.multiply(np.round(m), b1)
    B2 = np.linalg.norm(b2) ** 2

print("b1= ", b1, "b2= ", b2)
