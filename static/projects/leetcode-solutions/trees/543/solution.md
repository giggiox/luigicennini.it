{{< rawdetails title="543. Diameter of Binary Tree" link="https://leetcode.com/problems/diameter-of-binary-tree/" 
	desc="projects/leetcode-solutions/trees/543/description.html">}}
```python
diameter = [0]
def dfs(root):
    if not root:
        return 0       
    l = dfs(root.left)
    r = dfs(root.right)
    diameter[0] = max(diameter[0],l+r)
    return 1+ max(l,r) 
dfs(root)
return diameter[0]
```
diameter is the length of the longest path between any two nodes in a tree. This path may or may not pass through the root.


{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/trees/543/images/" >}}
{{< endrawdetails >}}


{{< endrawdetails >}}