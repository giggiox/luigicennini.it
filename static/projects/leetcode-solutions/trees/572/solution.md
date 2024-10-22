{{< rawdetails title="572. Subtree of Another Tree" link="https://leetcode.com/problems/subtree-of-another-tree/" >}}
```python
def sameTree(root1,root2):
    if not root1 and not root2:
        return True
    if not root1 and root2:
        return False
    if not root2 and root1:
        return False
    l = sameTree(root1.left, root2.left)
    r = sameTree(root1.right, root2.right)
    return l and r and root1.val == root2.val

def dfs(root,subRoot)->bool:
    if not root:
        return False
    if sameTree(root, subRoot):
        return True
    l = dfs(root.left, subRoot)
    r = dfs(root.right, subRoot)
    return l or r
return dfs(root,subRoot)
```

For each node, i check if it is the same tree. Check problem 100. Same Tree.



{{< endrawdetails >}}