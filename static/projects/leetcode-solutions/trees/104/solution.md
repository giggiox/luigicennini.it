{{< rawdetails title="104. Maximum Depth of Binary Tree" link="https://leetcode.com/problems/maximum-depth-of-binary-tree/"
	desc="projects/leetcode-solutions/trees/104/description.html">}}
```python
def dfs(root):
	if not root:
		return 0
	hl = dfs(root.left)
	hr = dfs(root.right)
	return 1 + max(hl, hr)
return dfs(root)
```

{{< rawdetails title="visualization" >}}
		{{< carousel path="projects/leetcode-solutions/trees/104/images/" >}}
{{< endrawdetails >}}


{{< rawdetails title="BFS solution" >}}
```python
q = deque([root])
level = 0
while q:
	for i in range(len(q)):
		v = q.popleft()
		if v.left:
			q.append(v.left)
		if v.right:
			q.append(v.right)
	level += 1
return level
```
{{< endrawdetails >}}

{{< endrawdetails >}}