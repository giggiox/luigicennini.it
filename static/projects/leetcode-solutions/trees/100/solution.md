{{< rawdetails title="100. Same Tree" link="https://leetcode.com/problems/same-tree/" 
	desc="projects/leetcode-solutions/trees/100/description.html" >}}
```python
def dfs(root1,root2):  
    if not root1 and not root2:
        return True
    if not root1 and root2:
        return False
    if root1 and not root2:
        return False
    a = dfs(root1.left,root2.left)
    b = dfs(root1.right,root2.right)
	return root1.val == root2.val and a and b
return dfs(p,q)
```

You can refactor this condition


```python
if not root1 and not root2:
    return True
if not root1 and root2:
    return False
if root1 and not root2:
    return False
```


Which true/false table is the following:
| root1    | root2 | output i want |
| -------- | ------- | ------- |
| T | T    | nothing |
| T | F    | F |
| F | T    | F |
| F | F    | T |

The condition becomes:
```python
if not root1 or not root2:
	return root1 == root2
```


{{< rawdetails title="Another way to do it" >}}

The comparison with the value can be at the beginning.
```python
def dfs(root1,root2):        
    if not root1 and not root2:
        return True
    if not root1 and root2:
        return False
    if root1 and not root2:
        return False
    if root1.val != root2.val:
        return False 
    a = dfs(root1.left,root2.left)
    b = dfs(root1.right,root2.right)
    return  a and b
return dfs(p,q)
```
{{< endrawdetails >}}

{{< endrawdetails >}}