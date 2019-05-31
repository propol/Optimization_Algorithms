import random

class Graph(object):
    def __init__(self, cost_matrix, rank):

        self.matrix = cost_matrix
        self.rank = rank

        self.pheromone = [[1 / (rank) for j in range(rank)] for i in range(rank)]


#beta value is considered to be = 0
class ACP(object):
    def __init__(self, ant_count, alpha, rho):
        self.rho = rho
        self.alpha = alpha
        self.ant_count = ant_count

    def update_pheromone(self, graph, ants):
        for i, row in enumerate(graph.pheromone):
            for j, col in enumerate(row):
                graph.pheromone[i][j] *= (1 - self.rho)
                for ant in ants:
                    graph.pheromone[i][j] += ant.pheromone_delta[i][j]

    def solve(self, graph):

        best_cost = float('inf')
        best_path = []


        ants = [Ant(self, graph) for i in range(self.ant_count)]

        for ant in ants:
            for i in range(graph.rank - 1):
                ant.select_next_node()

            if ant.total_cost < best_cost:
                best_cost = ant.total_cost
                best_path = ant.ant_path

            ant.update_pheromone_delta()
        self.update_pheromone(graph, ants)
        return best_path, best_cost


class Ant(object):
    def __init__(self, acp, graph):
        self.colony = acp
        self.graph = graph
        self.total_cost = 0.0
        self.ant_path = []
        self.pheromone_delta = []
        self.allowed = [i for i in range(graph.rank)]
        start = random.randint(0, graph.rank - 1)
        self.ant_path.append(start)
        self.current = start
        self.allowed.remove(start)

    def select_next_node(self):
        denominator = 0
        for i in self.allowed:
            denominator += self.graph.pheromone[self.current][i] ** self.colony.alpha * 1 #beta = 0

        probabilities = [0 for i in range(self.graph.rank)]

        for i in range(self.graph.rank):
            try:
                self.allowed.index(i)
                probabilities[i] = self.graph.pheromone[self.current][i] ** self.colony.alpha * 1 / denominator
            except ValueError:
                pass

        selected = 0
        rand = random.random()
        for i, probability in enumerate(probabilities):
            rand -= probability
            if rand <= 0:
                selected = i
                break
        self.allowed.remove(selected)
        self.ant_path.append(selected)
        self.total_cost += self.graph.matrix[self.current][selected]
        self.current = selected

    def update_pheromone_delta(self):
        self.pheromone_delta = [[0 for j in range(self.graph.rank)] for i in range(self.graph.rank)]

        for _ in range(1, len(self.ant_path)):
            i = self.ant_path[_ - 1]
            j = self.ant_path[_]
            self.pheromone_delta[i][j] = 1 / self.total_cost
