{{< rawdetails title="39. Combination Sum" link="https://leetcode.com/problems/combination-sum/" >}}

```python
res = []
def dfs(i,sa):
    if sum(sa) == target:
        res.append(sa.copy())
        return
    if sum(sa) > target:
        return    
    for j in range(i,len(candidates)):
		sa.append(candidates[j])
        dfs(j,sa)
		sa.pop()
dfs(0,[])
return res
```

{{< rawdetails title="visualization">}}
{{< carousel path="projects/leetcode-solutions/backtrack/39/images/" >}}
Or look at the tree with [this link](https://www.recursionvisualizer.com/?function_definition=res%20%3D%20%5B%5D%0Atarget%20%3D%207%0Acandidates%20%3D%20%5B2%2C3%2C6%2C7%5D%0Adef%20cs%28i%2Csa%29%3A%0A%20%20if%20sum%28sa%29%20%3D%3D%20target%3A%0A%20%20%20%20res.append%28sa.copy%28%29%29%0A%20%20%20%20return%0A%20%20if%20sum%28sa%29%20%3E%20target%3A%0A%20%20%20%20return%20%20%20%20%0A%20%20for%20j%20in%20range%28i%2Clen%28candidates%29%29%3A%0A%20%20%20%20cs%28j%2Csa%2B%5Bcandidates%5Bj%5D%5D%29%0A%20%20%20%20%20%20%20%20%0A%20%20%20%20%20%20%20%20%0A&function_call=cs%280%2C%5B%5D%29)
{{< endrawdetails >}}

{{< endrawdetails >}}