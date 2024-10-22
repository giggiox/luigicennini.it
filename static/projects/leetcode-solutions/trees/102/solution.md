{{< rawdetails title="102. Binary Tree Level Order Traversal" link="https://leetcode.com/problems/binary-tree-level-order-traversal/" >}}
```python
if not root:
    return []
q = deque([root])
out = []
while q:
    elem = []
    for i in range(len(q)):
        e = q.popleft()
        if e.left:
            q.append(e.left)
        if e.right:
            q.append(e.right)
        elem.append(e.val)
    out.append(elem)
return out
```
{{< endrawdetails >}}