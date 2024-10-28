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

{{< endrawdetails >}}