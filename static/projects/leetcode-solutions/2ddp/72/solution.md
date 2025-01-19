{{< rawdetails title="72. Edit Distance" link="https://leetcode.com/problems/edit-distance/description/"
	desc="projects/leetcode-solutions/2ddp/72/description.html">}}


{{< rawdetails title="top-down">}}
```python
def dfs(i, j):
	if i == len(word1):
		return len(word2) - j
	if j == len(word2):
		return len(word1) - i
	if word1[i] == word2[j]:
		return dfs(i + 1, j + 1)
	else:
		return 1 + min(dfs(i, j + 1), dfs(i + 1, j), dfs(i + 1, j + 1))
return dfs(0,0)
```
{{< endrawdetails >}}

{{< rawdetails title="bottom-up">}}
```python
dp = [[0 for j in range(len(word2) + 1)] 
	for i in range(len(word1) + 1)]
for i in range(len(word1) + 1):
	dp[i][len(word2)] = len(word1) - i
for j in range(len(word2) + 1):
	dp[len(word1)][j] = len(word2) - j
        
for i in range(len(word1) - 1, -1, -1):
	for j in range(len(word2) - 1, -1, -1):
		if word1[i] == word2[j]:
			dp[i][j] = dp[i+1][j+1]
		else:
			dp[i][j] = 1 + min(dp[i][j+1], dp[i+1][j], dp[i+1][j+1])
return dp[0][0]
```
{{< endrawdetails >}}

{{< endrawdetails >}}
