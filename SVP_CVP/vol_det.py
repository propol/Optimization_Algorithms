#Miscellaneous script
#Check whether the determinant of an open base of a lattice is equal to its orignial base
import numpy as np
import GA

original_base = np.array([[2.0, 1.0], [3.0, -1.0]])

open_base = np.array([[2.0, 1.0], [3.0, -1.0]])
GA.ga(open_base)

if np.linalg.det(original_base) == np.linalg.det(open_base):
    print("True")
else:
    print("False")
