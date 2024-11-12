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




All graphs visits have the same complexity.

$$ O( \sum_{v \in G} (1 + \tau(v))) = O( n + \sum_{v \in G} \tau(v))$$

Where $\tau(v)$ is the cost of the operation of getting incident edges for a given node $v$.
The cost of this operation depends on the graph representation.
- If it is a **edge list** then $\tau(v) = O(m)$ bacause we have to scan the whole list. So in this case it is $$O(n + nm) = O(nm)$$
- If it is **adjacency list** then $\tau(v) = O(\delta(v))$. Where $\delta(v)$ is the length of the list. So in this case it is $$O(n + 2m) = O(n + m)$$ Because for a foundamental property of undirected graphs we know that $\sum_{v \in V} \delta(v) = 2m$.
- If it is **adjacency matric** then $\tau(v) = O(n)$ because we have to scan the entire row. So in this case it is $$O(n + n^2) = O(n^2)$$





{{< endrawdetails >}}