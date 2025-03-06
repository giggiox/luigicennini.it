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

{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/2ddp/72/top-down/" >}}
	Or view interactive visualization with this [link](https://www.recursionvisualizer.com/?function_definition=word1%20%3D%20%22abd%22%0Aword2%20%3D%20%22acd%22%0Adef%20dfs%28i%2C%20j%29%3A%0A%09if%20i%20%3D%3D%20len%28word1%29%3A%0A%09%09return%20len%28word2%29%20-%20j%0A%09if%20j%20%3D%3D%20len%28word2%29%3A%0A%09%09return%20len%28word1%29%20-%20i%0A%09if%20word1%5Bi%5D%20%3D%3D%20word2%5Bj%5D%3A%0A%09%09return%20dfs%28i%20%2B%201%2C%20j%20%2B%201%29%0A%09else%3A%0A%09%09return%201%20%2B%20min%28dfs%28i%2C%20j%20%2B%201%29%2C%20dfs%28i%20%2B%201%2C%20j%29%2C%20dfs%28i%20%2B%201%2C%20j%20%2B%201%29%29%0A&function_call=dfs%280%2C0%29)
{{< endrawdetails >}}


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


{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/2ddp/72/bottom-up/" >}}
{{< endrawdetails >}}


{{< endrawdetails >}}

{{< endrawdetails >}}
