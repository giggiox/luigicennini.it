{{< rawdetails title="91. Decode Ways" link="https://leetcode.com/problems/decode-ways" 
	desc="projects/leetcode-solutions/dp/91/description.html">}}

{{< rawdetails title="Top-Down (memoization)" >}}
```python
memo = {}
def dfs(s):
    if s in memo:
		return memo[s]
    if len(s) == 0 or (len(s) == 1 and int(s) != 0):
        return 1
    l, r = 0, 0
    if int(s[0]) > 0:
        l = dfs(s[1:])
    if int(s[0:2]) > 9 and int(s[0:2]) < 27:
        r = dfs(s[2:])
    memo[s] = l + r
    return l + r
return dfs(s)
```
{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/dp/91/top-down/" >}}
{{< endrawdetails >}}


{{< endrawdetails >}}




{{< rawdetails title="bottom-up" >}}

In this case i strongly believe the memoization solution is better and easier because you don't have to handle a lot of edge cases involving zeros. Anyway here is the true dp solution.
```python
dp = {}
dp[""] = 1
for i in range(len(s)-1,-1,-1):
    sub = s[i:len(s)] 
    if int(sub[0]) > 0:
        dp[sub] = dp[sub[1:]]
    else:
        dp[sub] = 0
    if len(sub) > 1 and 9 < int(sub[0:2]) < 27:
        dp[sub] += dp[sub[2:]]
return dp[s]
```
{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/dp/91/bottom-up/" >}}
{{< endrawdetails >}}
{{< endrawdetails >}}


{{< endrawdetails >}}