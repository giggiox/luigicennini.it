{{< rawdetails title="78. Subsets" link="https://leetcode.com/problems/subsets/" >}}

```python
result = []
def dfs(i,sub):
    if i == len(nums):
        result.append(sub.copy())
        return
    sub.append(nums[i])
    dfs(i+1,sub)
    sub.pop()
    dfs(i+1,sub)
```

Python is convenient and you can squeeze down the append-recursiveCall-pop to just 1 line, like this:
```python
dfs(i+1,sub + [nums[i]])
```


{{< rawdetails title="visualization">}}
{{< carousel path="projects/leetcode-solutions/backtrack/78/sol1/" >}}
Or view interactive visualization with this [link](https://www.recursionvisualizer.com/?function_definition=nums%20%3D%20%5B1%2C2%2C3%5D%0Aresult%20%3D%20%5B%5D%0Adef%20backtrack%28i%2Csub%29%3A%0A%20%20%20%20if%20i%20%3D%3D%20len%28nums%29%3A%0A%20%20%20%20%20%20%20%20result.append%28sub.copy%28%29%29%0A%20%20%20%20%20%20%20%20return%0A%20%20%20%20sub.append%28nums%5Bi%5D%29%0A%20%20%20%20backtrack%28i%2B1%2Csub%29%0A%20%20%20%20sub.pop%28%29%0A%20%20%20%20backtrack%28i%2B1%2Csub%29&function_call=backtrack%280%2C%5B%5D%29)
{{< endrawdetails >}}



{{< rawdetails title="Another 'optimized' way to do it" >}}
```python
result = []
def dfs(i,sub):
    if i == len(nums):
		result.append(sub.copy())
        return
    for j in range(i,len(nums)):
        dfs(j+1,sub + [nums[j]])
```

{{< carousel path="projects/leetcode-solutions/backtrack/78/sol2/" >}}

Or view interactive visualization with this [link](https://www.recursionvisualizer.com/?function_definition=nums%20%3D%20%5B1%2C2%2C3%5D%0Aresult%20%3D%20%5B%5D%0Asub%20%3D%20%5B%5D%0Adef%20backtrack%28i%2Csub%29%3A%0A%20%20%20%20if%20i%20%3D%3D%20len%28nums%29%3A%0A%20%20%20%20%20%20%20%20return%0A%20%20%20%20for%20j%20in%20range%28i%2Clen%28nums%29%29%3A%0A%20%20%20%20%20%20%20%20backtrack%28j%2B1%2Csub%20%2B%20%5Bnums%5Bj%5D%5D%29%0A&function_call=backtrack%280%2C%5B%5D%29)

{{< endrawdetails >}}


{{< endrawdetails >}}