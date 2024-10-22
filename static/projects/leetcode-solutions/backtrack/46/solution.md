{{< rawdetails title="46. Permutations" link="https://leetcode.com/problems/permutations/" >}}

```python
res = []
def dfs(permutation):
    if len(permutation) == len(nums):
        res.append(permutation.copy())
        return
    for i in range(len(nums)):
        if not nums[i] in permutation:
            permutation.append(nums[i])
            dfs(permutation)
            permutation.pop()
dfs([])
return res
```


{{< rawdetails title="visualization">}}
{{< carousel path="projects/leetcode-solutions/backtrack/46/images/" >}}
Or view interactive visualization with this [link](https://www.recursionvisualizer.com/?function_definition=nums%20%3D%20%5B1%2C2%2C3%5D%0Ares%20%3D%20%5B%5D%0Adef%20dfs%28permutation%29%3A%0A%20%20%20%20if%20len%28permutation%29%20%3D%3D%20len%28nums%29%3A%0A%20%20%20%20%20%20%20%20res.append%28permutation.copy%28%29%29%0A%20%20%20%20%20%20%20%20return%0A%20%20%20%20for%20i%20in%20range%28len%28nums%29%29%3A%0A%20%20%20%20%20%20%20%20if%20not%20nums%5Bi%5D%20in%20permutation%3A%0A%20%20%20%20%20%20%20%20%20%20%20%20permutation.append%28nums%5Bi%5D%29%0A%20%20%20%20%20%20%20%20%20%20%20%20dfs%28permutation%29%0A%20%20%20%20%20%20%20%20%20%20%20%20permutation.pop%28%29&function_call=dfs%28%5B%5D%29)
{{< endrawdetails >}}


{{< endrawdetails >}}