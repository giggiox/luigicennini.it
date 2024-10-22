{{< rawdetails title="322. Coin Change" link="https://leetcode.com/problems/coin-change/" >}}


{{< rawdetails title="Naive" >}}
```python
def dfs(total):
    if total == 0:
        return 0
    if total < 0:
        return math.inf
    min_steps = math.inf
    for coin in coins:
        steps = dfs(total + coin)
        min_steps = min(min_steps, steps + 1)            
    return min_steps
result = dfs(amount)
return result if result != math.inf else -1
```

{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/dp/322/naive/" >}}
Or look at the tree with [this link]()
{{< endrawdetails >}}

{{< endrawdetails >}}



{{< rawdetails title="Top-Down (memoization)" >}}
```python
memo = {}
def dfs(total):
    if total in memo:
        return memo[total]
    if total == 0:
        return 0
    if total < 0:
        return math.inf
    min_steps = math.inf
    for coin in coins:
        steps = dfs(total + coin)
        min_steps = min(min_steps, steps + 1)            
    memo[total] = min_steps
    return min_steps
result = dfs(amount)
return result if result != math.inf else -1
```
{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/dp/322/top-down/" >}}	
Or look at the tree with [this link]()
{{< endrawdetails >}}
{{< endrawdetails >}}



{{< rawdetails title="bottom-up (true dp)" >}}
```python
dp = [amount + 1] * (amount + 1)
dp[0] = 0
for a in range(1, amount + 1):
    for c in coins:
        if a - c >= 0:
            dp[a] = min(dp[a], 1 + dp[a - c])
return dp[amount] if dp[amount] != amount + 1 else -1
```
{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/dp/322/bottom-up/" >}}	
{{< endrawdetails >}}
{{< endrawdetails >}}



{{< endrawdetails >}}