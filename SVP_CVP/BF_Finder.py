import numpy as np
import sympy as sym

a = np.array([2, 1])
b = np.array([3, -1])
target = np.array([1, 0])

m = sym.Symbol('m')
l = sym.Symbol('l')

L = m*a + l*b

m, l = -10, -10
found = False

while m <= 10:
    while l <= 10:
        L = m*a + l*b
        if L is target:
            found = True
            break
        l += 1
    if found == True:
        break
    l = -10
    m += 1

if found == True:
    print(target, " belongs in L.")
else:
    print(target, "does not belong in L.")