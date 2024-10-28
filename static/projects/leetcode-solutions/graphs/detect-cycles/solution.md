{{< rawdetails title="detect cycles"  >}}

Detecting a cycle in a graph can be implemented using
1. topological sort using BFS
2. using a 3 state nodes configuration.


So, instead of only visited/unvisited, we will have 3 states: unvisited/currently being visited/visited.
But why do we need 3 states?




{{< carousel path="projects/leetcode-solutions/graphs/detect-cycles/images/" >}}


Let's implement the 3 state visit in python:


```python
UNVISITED = 0
CURRENTLY_VISITING = 1
VISITED = 2
states = [0] * numCourses
def dfs(i):
    if states[i] == VISITED:
        return True
    states[i] = CURRENTLY_VISITING
    for v in adjList[i]:
        if states[v] == CURRENTLY_VISITING:
            return False
        a = dfs(v)
         if not a:
            return False
    states[i] = VISITED
    return True

for i in range(numCourses):
    if not dfs(i):
        return False
return True
```


{{< endrawdetails >}}
