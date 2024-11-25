{{< rawdetails title="45. Jump Game II" link="https://leetcode.com/problems/jump-game-ii/description/"
	desc="projects/leetcode-solutions/dp/45/description.html">}}


{{< rawdetails title="DFS with memoization" >}}
```python
cache = {}
def dfs(i):
    if i in cache:
        return cache[i]
    if i >= len(nums) - 1:
        return 0
    minn = math.inf
    for j in range(nums[i]):
        minn = min(minn, dfs(j+1+i) + 1)
    cache[i] = minn
    return minn
return dfs(0)
```
{{< endrawdetails >}}


{{< rawdetails title="true dp" >}}
```python
n = len(nums)
dp = [0] * n
dp[n - 1] = 0
for i in range(n-2,-1,-1):
    minn = math.inf
    j = 1
    while j <= nums[i]:
        if i + j < n:
            minn = min(dp[i+j]+1,minn)
        j+= 1
    dp[i] = minn
return dp[0]
```
{{< endrawdetails >}}



{{< endrawdetails >}}
