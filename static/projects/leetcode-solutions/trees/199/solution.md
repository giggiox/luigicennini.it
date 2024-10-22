{{< rawdetails title="199. Binary Tree Right Side View" link="https://leetcode.com/problems/binary-tree-right-side-view/" >}}
```python
if not root:
    return 
d = deque([root])
out = []
while d:
    l = []
    for i in range(len(d)):
        n = d.popleft()
        if n.left:
            d.append(n.left)
        if n.right:
            d.append(n.right)
        l.append(n.val)
    out.append(l[-1])
return out
```
Watch before problem 102. Binary Tree Level Order Trasversal

{{< endrawdetails >}}