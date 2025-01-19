{{< rawdetails title="visits" >}}

{{< rawdetails title="BFS">}}
```python
def bfs(root):
	q = deque([root])
	mark root
	while q:
		u = q.popleft()
		for all edges(u,v):
			if v is not marked:
				mark v
				q.append(v)
```

{{< rawdetails title="BFS trees">}}
We can construct a BFS tree while doing BFS.
```python
def bfs(root):
	T = [root] # Tree
	q = deque([root])
	mark root
	while q:
		u = q.popleft()
		for all edges(u,v):
			if v is not marked:
				mark v
				q.append(v)
				make v son of u in T
```

The constructed tree has some nice properties, one of which being that it gives us the distance (shortest path) from the root to any other node.
For an unweighted graph, the BFS tree ensures that the path from the root to any node in the tree corresponds to the shortest path (in terms of the number of edges) from the root to that node in the original graph.
This property makes BFS useful for finding shortest paths in unweighted graphs.

**Example**:
{{< includeImage path="/projects/leetcode-solutions/graphs/visits/images/bfstree.png" >}}

Denoting $d(u,v)$ as the shortest path between $u$ and $v$, we get that 

$$d(1,2) = 1$$
$$d(1,5) = 1$$
$$d(1,6) = 1$$
$$d(1,3) = 2$$
$$d(1,4) = 2$$





{{< endrawdetails >}}



{{< endrawdetails >}}

{{< rawdetails title="DFS-recurisve">}}
```python
def dfs(u):
	mark u
	for all edges(u,v):
		if v is not marked:
			dfs(v)
```
{{< endrawdetails >}}

{{< rawdetails title="DFS-iterative">}}
```python
def dfs(root):
	s = [root]
	mark root
	while s:
		u = s.pop()
		for all edges(u,v):
			if v is not marked:
				mark v
				s.append(v)
```
{{< endrawdetails >}}



{{< rawdetails title="time and space complexity" >}}

All graphs visits have the same complexity.

$$ O( \sum_{v \in G} (1 + \tau(v))) = O( n + \sum_{v \in G} \tau(v))$$

Where $\tau(v)$ is the cost of the operation of getting incident edges for a given node $v$.
The cost of this operation depends on the graph representation.
- If it is a **edge list** then $\tau(v) = O(m)$ bacause we have to scan the whole list. So in this case it is $$O(n + nm) = O(nm)$$
- If it is **adjacency list** then $\tau(v) = O(\delta(v))$. Where $\delta(v)$ is the length of the list. So in this case it is $$O(n + 2m) = O(n + m)$$ Because for a foundamental property of undirected graphs we know that $\sum_{v \in V} \delta(v) = 2m$.
- If it is **adjacency matric** then $\tau(v) = O(n)$ because we have to scan the entire row. So in this case it is $$O(n + n^2) = O(n^2)$$

The space complexity is 
$$S(n) = O(n + m)$$

{{< endrawdetails >}}





{{< endrawdetails >}}