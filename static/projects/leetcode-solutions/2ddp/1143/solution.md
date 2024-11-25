{{< rawdetails title="1143. Longest Common Subsequence" link="https://leetcode.com/problems/longest-common-subsequence/description/"
	desc="projects/leetcode-solutions/2ddp/1143/description.html">}}



{{< rawdetails title="top-down">}}
```python
def dfs(i, j):
    if i == len(text1) or j == len(text2):
		return 0
	if text1[i] == text2[j]:
        return 1 + dfs(i + 1, j + 1)
	else:
		return max(dfs(i + 1, j), dfs(i, j + 1))        
return dfs(0, 0)
```

{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/2ddp/1143/top-down/" >}}
{{< endrawdetails >}}

{{< endrawdetails >}}

{{< rawdetails title="bottom-up">}}
```python
dp = [[0 for j in range(len(text2) + 1)] 
	for i in range(len(text1) + 1)]
for i in range(len(text1) - 1, -1, -1):
	for j in range(len(text2) - 1, -1, -1):
		if text1[i] == text2[j]:
			dp[i][j] = 1 + dp[i + 1][j + 1]
		else:
			dp[i][j] = max(dp[i][j + 1], dp[i + 1][j])                            
return dp[0][0]
```
{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/2ddp/1143/bottom-up/" >}}
{{< endrawdetails >}}
{{< endrawdetails >}}

{{< endrawdetails >}}
