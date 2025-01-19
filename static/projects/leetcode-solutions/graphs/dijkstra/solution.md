{{< rawdetails title="dijkstra" >}}
Given a directed and weighted graph (with positive weights), Dijkstra's algorithm returns the shortest path from the source node to all other nodes in the graph.


```
def dijkstra(root):
	dist[v] = inf, for all v in V
	dist[root] = 0
	q = [root]
	while q:
		u = min(dist[v]: v in q)
		q = q.remove(u)
		∀(u,v) in E:
			if dist[v] > dist[u] + w[u,v]:
				dist[v] = dist[u] + w[u,v]
				q = q.append(v)
	# output dist (array containing distance from source to all nodes)
```



Can be implemented in python in this way (using a priority queue):
```python
def dijkstra(root):
	pq = []
	heapq.heappush(pq, (0,root))
	dist = [float('inf')] * n
	dist[root] = 0
	while pq:
		d, u = heapq.heappop(pq)
		for v, weight in self.adjList[u]:
			if dist[v] > dist[u] + weight:
				dist[v] = dist[u] + weight
				heapq.heappush(pq, (dist[v], v))
```

The time complexity is $O((|V| + |E|)*log|V|)$.


{{< endrawdetails >}}