{{< rawdetails title="300. Longest Increasing Subsequence" link="https://leetcode.com/problems/longest-increasing-subsequence/description/"
	desc="projects/leetcode-solutions/dp/300/description.html">}}



{{< rawdetails title="top-down (memoization)">}}
```python
memo = {}
def dfs(i):
	if i == len(nums):
		return 0 
	if i in memo:
		return memo[i]
	a = 0
	for j in range(i+1,len(nums)):
		if i == -1 or nums[j] > nums[i]:
			a = max(a, dfs(j) + 1)
    memo[i] = a
	return a
return dfs(-1)
```

{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/dp/300/top-down/" >}}
Or look at the tree with [this link](https://www.recursionvisualizer.com/?function_definition=nums%20%3D%20%5B1%2C2%2C4%2C3%5D%0Adef%20dfs%28i%29%3A%0A%20%20if%20i%20%3D%3D%20len%28nums%29%3A%0A%20%20%20%20return%200%20%0A%20%20a%20%3D%200%0A%20%20for%20j%20in%20range%28i%2B1%2Clen%28nums%29%29%3A%0A%20%20%20%20if%20i%20%3D%3D%20-1%20or%20nums%5Bj%5D%20%3E%20nums%5Bi%5D%3A%0A%20%20%20%20%20%20a%20%3D%20max%28a%2C%20dfs%28j%29%20%2B%201%29%0A%20%20return%20a%0A%20%20%20%20%20%20%20%20%20%0A%20%20&function_call=dfs%28-1%29)
{{< endrawdetails >}}

{{< endrawdetails >}}

{{< rawdetails title="bottom-up">}}
```python
n = len(nums)
LIS = [0] * (n+1)
for i in range(n-1,-1,-1):
	a = 0
	for j in range(i+1,n+1):
		a = max(a, LIS[j] + 1 if nums[i-1] < nums[j-1] or i == 0 else 0)
	LIS[i] = a
return LIS[0]
```

{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/dp/300/bottom-up/" >}}
{{< endrawdetails >}}

{{< endrawdetails >}}


{{< endrawdetails >}}