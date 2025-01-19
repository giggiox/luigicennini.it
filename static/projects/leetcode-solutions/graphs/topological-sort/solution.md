{{< rawdetails title="topological sort" >}}
Problem statment:

> Given a DAG (directed *acyclic* graph) a topological sort is a linear ordering of all vertices such that for any edge (u, v), u comes before v in the ordering.


A Directed Acyclic Graph (DAG) is a directed graph with no cycles. That is, if for any pair of nodes x and y, either the path from x to y or the path from y to x does not exist.

![](/projects/leetcode-solutions/graphs/topological-sort/images/0.PNG)

So a topological ordering for the graph in the photo is: $[1,4,2,3,5,6]$.
There are other possible topological ordering, for example $[1,4,5,6,2,3]$.

{{< rawdetails title="using DFS" >}}

```python
def dfs(node):
	mark node as visited
	for (node,v) in edges:
		if v not visited:
			dfs(v)
	out.append(node)

out = []
for each node:
	if node not visited:
		dfs(node)
return out.reverse()
```

Be aware

> This DFS algorithm runs fine and outputs a order for a graph even if the graph contains cycles. If you want an algorithm that can create a topological ordering but also detecting if the graph contains a cycle you have to use the BFS solution described below.


Let's see an example of how the algorithm works:

{{< carousel path="projects/leetcode-solutions/graphs/topological-sort/1/" >}}


The outuput does not depend on the node we start with. This is because we loop through all nodes and we run dfs on them.
For this reason, let's see another example, starting from another node.

{{< carousel path="projects/leetcode-solutions/graphs/topological-sort/2/" >}}

It can be proved that the above is a topological ordering.

**Theorem**: The algorithm above provides a topological ordering.

**Proof**: Remember that a topological ordering is an ordering where $\forall(x,y) \in E$, $x$ appear before $y$ in the ordering.
So in this case it has to be $out(x) > out(y)$ (where it's $>$ and not $<$ because we output $out$ values in descending order).
Notice how when we are doing $dfs(x)$ there are 2 cases:
1. Node $y$ is already visited, in this case, the $out$ time of $y$ is for sure less than the one from $x$.
2. Node $y$ has to be visited, in this case, we will then start a $dfs(y)$ that will terminate making $out(y) < out(x)$.






{{< endrawdetails >}}


{{< rawdetails title="using BFS" tag="can be used to detect cycles">}}

```python
indegree = an array indicating indegrees for each node
queue = []
# Add to the BFS queue all nodes with indegree 0
for i in indegree:
    if indegree[i] == 0:
        queue.append(i)
		
out = []
while q:
	u = q.popleft()
	out.append(u)
	for (u,v) in edges:
		indegree[v] -= 1
		if indegree[v] == 0:
			queue.append(v)
			
if len(out) == n:
	return out
else:
	return "graphs contains a cycle"

```

{{< carousel path="projects/leetcode-solutions/graphs/topological-sort/3/" >}}


## Topological ordering with BFS can be used to detect cycles

You can see how in the example below:

{{< carousel path="projects/leetcode-solutions/graphs/topological-sort/4/" >}}


{{< endrawdetails >}}

{{< endrawdetails >}}