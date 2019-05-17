from aco import *

def main():

    nodes = []
    with open('./nodes/nodes.txt') as f:
        for line in f.readlines():
            node = line.split(' ')
            nodes.append(dict(index=int(node[0]), x=int(node[1]), y=int(node[2])))


    cost_matrix = [[0, 5, 7, 3], [5, 0, 5, 6], [7, 5, 0, 5], [3, 6, 5, 0]]
    rank = len(nodes)

    print(cost_matrix[0])
    print(cost_matrix[1])
    print(cost_matrix[2])
    print(cost_matrix[3])

    aco = ACP(1000, 2, 0.5)
    graph = Graph(cost_matrix, rank)
    path, cost = aco.solve(graph)
    print('cost: {}, path: {}'.format(cost, path))

if __name__ == '__main__':
    main()
