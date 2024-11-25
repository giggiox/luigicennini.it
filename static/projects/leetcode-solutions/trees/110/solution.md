{{< rawdetails title="110. Balanced Binary Tree" link="https://leetcode.com/problems/balanced-binary-tree/" 
	desc="projects/leetcode-solutions/trees/110/description.html">}}
```python
def dfs(root):
    if not root:
        return (True,0)
    b1,h1 = dfs(root.left)
    b2,h2 = dfs(root.right)
    if b1 and b2 and abs(h1-h2)<=1:
        return (True,max(h1,h2)+1)
    else:
        return (False,max(h1,h2)+1)   
return dfs(root)[0]
```


{{< endrawdetails >}}