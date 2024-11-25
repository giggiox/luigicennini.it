{{< rawdetails title="236. lowest-common-ancestor-of-a-binary-tree" link="https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-tree" 
	desc="projects/leetcode-solutions/trees/236/description.html">}}
```python
def dfs(root, v, path):      
	if not root:
        return False
    path.append(root.val)
    if root.val == v:
        return True
    fl = dfs(root.left, v, path)
    if fl:
        return True
    fr = dfs(root.right, v, path)
    if fr:
        return True
    path.pop()
    return False

p1, p2 = [], []
dfs(root,p.val,p1)
dfs(root,q.val,p2)
i = 0
ret = None
while i < len(p1) and i < len(p2):
    if p1[i] != p2[i]:
        break
    ret = p1[i]
    i+=1
return TreeNode(ret)
```

{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/trees/236/images/" >}}
{{< endrawdetails >}}


{{< endrawdetails >}}