{{< rawdetails title="200. Number of Islands" link="https://leetcode.com/problems/number-of-islands/" >}}

```python
def bfs(i,j):
    q = deque([(i,j)])
    grid[i][j] = '0'
    while q:
        r,c = q.popleft()
        if r+1 in range(len(grid)) and grid[r+1][c] == '1':
            q.append((r+1,c))
            grid[r+1][c] = '0'
        if r-1 in range(len(grid)) and grid[r-1][c] == '1':
            q.append((r-1,c))
            grid[r-1][c] = '0'
        if c+1 in range(len(grid[0])) and grid[r][c+1] == '1':
            q.append((r,c+1))
            grid[r][c+1] = '0'
        if c-1 in range(len(grid[0])) and grid[r][c-1] == '1':
            q.append((r,c-1))
            grid[r][c-1] = '0' 
count = 0
for i in range(len(grid)):
	for j in range(len(grid[0])):
        if grid[i][j] == '1':
            bfs(i,j)
            count +=1
return count
```

{{< rawdetails title="DFS solution">}}
```python
def dfs(self, grid, i, j):
	if i<0 or j<0 or i>=len(grid) or j>=len(grid[0]) or grid[i][j] != '1':
        return
    grid[i][j] = '#'
    self.dfs(grid, i+1, j)
    self.dfs(grid, i-1, j)
    self.dfs(grid, i, j+1)
    self.dfs(grid, i, j-1)

count = 0
for i in range(len(grid)):
    for j in range(len(grid[0])):
        if grid[i][j] == '1':
            self.dfs(grid, i, j)
            count += 1
return count
```
{{< endrawdetails >}}


{{< endrawdetails >}}