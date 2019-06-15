from time import time
import subset_alg

def main():
    x_list = [10, 2, 4, 3, 1]
    target= 5

    time_start = time()
    ss = subset_alg.subset_alg(x_list, target)
    time_end = time()
    
    print('Subset found:', ss, time_end - time_start)
    

if __name__ == '__main__':
    main()
