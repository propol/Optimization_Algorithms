import knapsack

def main():
    a, a0, hamming = knapsack.find_random(10,1,5)
    print(knapsack.knapsack_matrix(a, a0, hamming))
    #print(a,a0,hamming)
    

if __name__ == '__main__':
    main()
