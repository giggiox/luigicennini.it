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


{{< endrawdetails >}}