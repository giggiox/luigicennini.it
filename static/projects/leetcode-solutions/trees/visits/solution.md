{{< rawdetails title="visits" >}}


{{< rawdetails title="DFS" >}}
```python
def dfs(root):
	if not root:
		return
	hl = dfs(root.left)
	hr = dfs(root.right)
	return
```
{{< rawdetails title="visualization" >}}
		{{< carousel path="projects/leetcode-solutions/trees/visits/dfs/" >}}
{{< endrawdetails >}}
{{< endrawdetails >}}

{{< rawdetails title="BFS" >}}
```python
q = deque([root])
while q:
	v = q.popleft()
	if v.left:
		q.append(v.left)
	if v.right:
		q.append(v.right)
```
{{< rawdetails title="visualization" >}}
		{{< carousel path="projects/leetcode-solutions/trees/visits/bfs/" >}}
{{< endrawdetails >}}
{{< endrawdetails >}}

{{< rawdetails title="DFS iterative" >}}
```python
q = []
while q:
	v = q.pop()
	if v.right:
		q.append(v.right)
	if v.left:
		q.append(v.left)
```
remember to put the right part first in the stack.
{{< rawdetails title="visualization" >}}
		{{< carousel path="projects/leetcode-solutions/trees/visits/dfs-iterative/" >}}
{{< endrawdetails >}}
{{< endrawdetails >}}


The time complexity of all visits is
$$O(n)$$

Because we can write the complexity of the visit like this $$T(n) = T(k) + T(n-k-1)  + 1$$ where k is the number of nodes on one side of the root and n-k-1 on the other side.
Let's take in account 2 cases:
- right skewed tree: we have $T(n) = T(0) + T(n-1) + 1$. The solution of this recursive relation is $$T(n) = O(n)$$
- balanced tree (both left and right subtrees have an equal number of nodes): $T(n) = T(n/2) +T(n/2) + 1$. The solution of this recursive relation is $$T(n) = O(n)$$


{{< endrawdetails >}}