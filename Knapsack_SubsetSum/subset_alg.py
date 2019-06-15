def subset_alg(x_list, target):
    ndict = dict()
    result, _ = g(x_list, x_list, target, ndict)
    return (sum(result), result)


def g(v, w, S, ndict):
    subset = []
    id_subset = []
    for i, (x, y) in enumerate(zip(v, w)):
        
        if f(v, i + 1, S - x, ndict) > 0:
            subset.append(x)
            id_subset.append(y)
            S -= x
    return subset, id_subset


def f(v, i, S, ndict):
    if i >= len(v):
        return 1 if S == 0 else 0
    if (i, S) not in ndict:    
        count = f(v, i + 1, S, ndict)
        count += f(v, i + 1, S - v[i], ndict)
        ndict[(i, S)] = count  
    return ndict[(i, S)]       
