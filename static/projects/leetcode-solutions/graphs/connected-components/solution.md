{{< rawdetails title="connected and strongly connected components" >}}


**Definition (connected component)**: 
In an **undirected graph**, a connected component is a maximal subset of vertices such that there is a path between any pair of vertices in the subset.

**Definition (strongly connected component SCC)**: 
In a **directed graph**, a strongly connected component (SCC) is a maximal subset of vertices such that for every pair of vertices u and v in the SCC, there exists::

1. A directed path from u to v, and
2. A directed path from v to u.


{{< rawdetails title="finding connected components" >}}
Finding all connected components is easy:

```
CC <- {}
candidates <- {1,2,...,n}
while candidates:
	x <- pick one vertex from candidates
	A(x) <- dfs(G, x) # You can replace dfs with bfs
	CC <- CC ∪ A(x)
	candidates <- candidates \ A(x)
```

The algorithm simply marks every vertex found during the visit as part of a connected component.


The complexity of this algorithm is $O(V + E)$.

{{< endrawdetails >}}


{{< rawdetails title="finding strongly connected components" >}}

We can derive a naive algorithm for strongly connected components:
```
SCC <- {}
candidates <- {1,2,...,n}
while candidates:
	x <- pick one vertex from candidates
	A(x) <- dfs(G, x)
	B(x) <- dfs(G^T, x)
	C(x) <- A(x) ∩ B(x)
	SCC <- SCC ∪ C(x)
	candidates <- candidates \ C(x)
```

The time complexity of this algorithm is $O((m+n)n)$.
We can do better using **Kosaraju's algorithm**:

```
do a dfs to compute finishing times f (a topological ordering)
compute G^T
SCC <- {}
pop vertex x with biggest f:
	A(x) <- dfs(G^T, x)
	SCC <- SCC ∪ A(x)
```

The time complexity of this algorithm is $O(m + n)$.


{{< rawdetails title="Kosaraju's algorithm intuition and proof" >}}
Take the following graph:

{{< includeImage path="/projects/leetcode-solutions/graphs/connected-components/images/kosaraju1.png" >}}

You can see that there are two SCCs (strongly connected components) in this graph.

{{< includeImage path="/projects/leetcode-solutions/graphs/connected-components/images/kosaraju2.png" >}}


If you apply a naive algorithm starting from node 1, you might end up visiting SCC #2 as part of the same traversal. 
This inefficiency highlights the limitations of the naive approach. 
Kosaraju's algorithm addresses this issue by ensuring that SCCs are explored independently.
The key idea behind Kosaraju's algorithm is:


> If we determine a specific ordering of the vertices, we can use it to perform visits in a way that avoids spilling into other SCCs.

In the example above, if you start from any vertex in SCC #2, Kosaraju's algorithm ensures you won’t end up visiting SCC #1.


## The Topological Ordering



TThe "specific ordering" mentioned above is the topological order.
A topological ordering is defined such that $\forall (x,y) \in E$, $x$ always precedes $y$ in the ordering.

### Algorithm for topolgical ordering
The following pseudocode demonstrates how to compute a topological ordering using a DFS traversal:

```python
timer = 0

def dfs(x):
	s(x) = timer + 1
	timer += 1
	...
	#  Performs dfs as usual
	...
	f(x) = timer + 1
	timer += 1
	
# Output f values in descending order
```

For every node, we record its *starting time* (s) and *finishing time* (f) during the DFS traversal. 
The vertices are then ordered by their finishing times in descending order to achieve the topological ordering.

### Theorem: The DFS Algorithm Induces a Topological Ordering

**Proof**: We have to prove that $\forall (x,y) \in E,$  the finishing time $f(x) > f(y)$ (> and not < because we output f values in descending order).
When we do $dfs(x)$ there are 2 cases:
1. $y$ has already been visited, in this case $dfs(y)$ has already been done and we will get $f(y)<f(x)$.
2. $y$ has to be visited, in this case $dfs(x)$ will start $dfs(y)$ and it will finish before $dfs(x)$ so we will again get $f(y)<f(x)$.
Thus, in both cases, $f(x)>f(y)$, proving that the algorithm produces a valid topological ordering.


### Kosaraju's theorem and SCCs

The kosajaru's algorithm rely on this theorem:

**Theorem (kosajaru)**: Given $scc_1$ and $scc_2$ 2 scc of $G$. $(u,v) \in E : u \in scc_1, v \in scc_2$. Denoting $f(scc_i)$ as the highest finishint time in $scc_i$ and $s(scc_i)$ as the lowest starting time in $scc_i$.
Then $f(scc_1) > f(scc_2)$.

**Proof**: There are 2 cases:

1. $s(scc_1) < s(scc_2)$ (we started a dfs visit from a node in $scc_1$)

So we are in this kind of situation


{{< includeImage path="/projects/leetcode-solutions/graphs/connected-components/images/kosaraju3.png" >}}


Let $(y,z)$ the first edge we encounter in the visit.
We will have $f(scc_1) = f(x) > f(y) > f(scc_2)$
We get the last $>$ because once we enter $scc_2$, there is no back edge from $scc_2$ to $scc_1$ (this is the **key** of the proof).
It can be proven that the scc's graph is a DAG (because, if there was a back edge, it would not be a maximal scc).

2. $s(scc_1) > s(scc_2)$ (we started a dfs visit from a node in $scc_2$)

So we are in this kind of situation


{{< includeImage path="/projects/leetcode-solutions/graphs/connected-components/images/kosaraju4.png" >}}

$f(scc_2) = f(x) < s(scc_1) < f(scc_2)$

We get $f(x) < s(scc_1)$ because from $scc_2$ there is no way to go to $scc_1$.



### How Kosaraju's theorem is used in SCC algorithm
Let's revise the Kosaraju's algorithm:

```
do a dfs to compute finishing times f (a topological ordering)
compute G^T
SCC <- {}
pop vertex x with biggest f:
	A(x) <- dfs(G^T, x)
	SCC <- SCC ∪ A(x)
```

When i'm taking the biggest finishing time i'm in this situation:
{{< includeImage path="/projects/leetcode-solutions/graphs/connected-components/images/kosaraju5.png" >}}



And to remain inside the $scc$ we reverse the edges. 
{{< includeImage path="/projects/leetcode-solutions/graphs/connected-components/images/kosaraju6.png" >}}

Notice how there are no edges going from $scc_1$ to $scc_2$ so when performing the dfs it will remain inside $scc_1$.

{{< endrawdetails >}}

{{< endrawdetails >}}








{{< endrawdetails >}}

