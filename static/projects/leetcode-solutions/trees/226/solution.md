{{< rawdetails title="226. Invert Binary Tree" link="https://leetcode.com/problems/invert-binary-tree/" 
	desc="projects/leetcode-solutions/trees/226/description.html">}}
```python
def invertTree(self, root):
    if not root:
        return
    root.left, root.right = root.right,root.left
    self.invertTree(root.left)
    self.invertTree(root.right)
    return root
```

{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/trees/226/images/" >}}
{{< endrawdetails >}}


{{< endrawdetails >}}