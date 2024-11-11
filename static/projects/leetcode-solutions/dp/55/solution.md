{{< rawdetails title="55. Jump Game" >}}


{{< rawdetails title="DFS with memoization" >}}
```python
cache = {}
def dfs(i):
    if i in cache:
        return cache[i]
    if i == len(nums) - 1:
        return True
    tmp = False
        for j in range(nums[i]):
            tmp = tmp or dfs(j+1+i)
    cache[i] = tmp
    return tmp
return dfs(0)
```
{{< endrawdetails >}}


{{< rawdetails title="true dp" >}}
```python
n = len(nums)
dp = [False] * n
dp[n - 1] = True
for i in range(n-2,-1,-1):
    found = False
    j = 1
    while j <= nums[i] and not found:
        if i+j < n and dp[i + j]:
			dp[i] = True
			found = True
        j+= 1
return dp[0]
```
{{< endrawdetails >}}


{{< rawdetails title="greedy solution" >}}
```python
goal = len(nums)-1
for i in range(goal-1,-1,-1):
    if i+nums[i] >= goal:
        goal = i
return goal == 0
```
{{< endrawdetails >}}



{{< endrawdetails >}}
