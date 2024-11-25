{{< rawdetails title="617. Merge Two Binary Trees" link="https://leetcode.com/problems/merge-two-binary-trees/" 
	desc="projects/leetcode-solutions/trees/617/description.html">}}
```python
def dfs(root1, root2):
    if not root1:
        return root2
    if not root2:
        return root1
    tree = TreeNode(root1.val + root2.val)
    tree.left = dfs(root1.left, root2.left)
    tree.right = dfs(root1.right, root2.right)
    return tree
return dfs(root1, root2)
```
{{< endrawdetails >}}