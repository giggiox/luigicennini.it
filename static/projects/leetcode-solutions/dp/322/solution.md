{{< rawdetails title="322. Coin Change" link="https://leetcode.com/problems/coin-change/" 
	desc="projects/leetcode-solutions/dp/322/description.html">}}


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
{{< endrawdetails >}}


{{< rawdetails title="time and space complexity" >}}
Time complexity:
$$T(n) = nT(t-1) + 1$$
$$= n(nT(t-2)) + 1) + 1$$
$$...$$
$$= O(n^t)$$

In the worst case we have in the available coins, a coin with value $1$. In this case the total amount is each time decreased by $1$.

Space complexity: 
$$S(n) = O(t)$$
It is the depth of the recursion stack at max, which is $t$.

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
{{< endrawdetails >}}

{{< rawdetails title="time and space complexity" >}}
Time complexity:
$$T(n) = O(n*t)$$
In the memoized solution, the time complexity is always the maximum length of the cache. 

Space complexity: 
$$S(n) = O(t)$$
It is the depth of the recursion stack at max, which is $t$.

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

{{< rawdetails title="time and space complexity" >}}
Time complexity:
$$T(n) = O(n*t)$$

Space complexity: 
$$S(n) = O(t)$$

{{< endrawdetails >}}



{{< endrawdetails >}}



{{< endrawdetails >}}