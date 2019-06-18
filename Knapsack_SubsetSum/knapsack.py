from fpylll import * 
import random,math,operator,time 
from operator import itemgetter 
import numpy as np 
from __future__ import division 
from numpy import matrix 
from numpy import linalg as LA 
from numpy import matlib

def rand_bin_array(K, N):
    arr = np.array([0] * K + [1] * (N - K))
    np.random.shuffle(arr)
    return arr

def find_random(n, d, hamming):
    a = [random.randint(1, np.floor(2**((2-d)*n))) for _ in range(n)]
    density = float(len(a) / math.log(max(a),2))
    solution = rand_bin_array(n-hamming,n)
    a0 = np.dot(solution, a)
    #return a, a0, density, sum(solution), len(solution), solution
    return a,a0,sum(solution)

def fp2mat(A): 
    L = np.zeros(shape=(A.nrows,A.ncols)) 
    for i in range(A.nrows): 
        for j in range(A.ncols): 
            L[i,j] = A[i,j] 
            L = np.array(L) 
    return L 

def mat2fp(A): 
    L = matrix([A.shape[0],A.shape[1]])
    for i in range(A.shape[0]): 
        for j in range(A.shape[1]): 
            L[i,j] = int(A[i,j]) 
    return L 

def checking(b,n): 
    i=0 
    x=np.array([0 for _ in range(n)]) 
    check=(int(abs(b[n+1]))==1) 
    while (check==True)&(i<n): 
        check=(int(abs(b[i]))==1) 
        i=i+1 
        if (i==n) & (check==True) & (b[n]==0) & (b[n+2]==0): 
            for j in range(n): 
                x[j]=abs(b[j]-b[n+1])/2 
                return 'Solution found!',x 
            else: 
                return "There's no solution" 
            
def knapsack_matrix(a,a0,hamming): 
    density=float(len(a)/math.log(max(a),2))
    n = len(a) 
    N=int(np.sqrt(n))+2 
    L=matrix([[N*int(a[i]) for i in range(0, n)],[0 for i in range(0, n)],[N for i in range(0, n)]])
    L=L.T
    M1 = np.matlib.identity(n) 
    M1 = 2*M1; Mb = np.bmat([M1,L])
    zerom = matrix([1 for i in range(0, n)]) 
    zerom1 = np.bmat([zerom,matrix(N*int(a0)),matrix(1),matrix(int(hamming*N))]) 
    B = np.vstack([Mb,zerom1])
    B=mat2fp(B) 
    return B 
