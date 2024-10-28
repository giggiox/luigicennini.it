{{< rawdetails title="130. Surrounded Regions" link="https://leetcode.com/problems/surrounded-regions/" >}}

```python
rows, cols= len(board), len(board[0])
def dfs(r,c): 
    if (r<0 or r==rows or c<0 or c==cols or board[r][c]!="O"):
        return 
    board[r][c]="T"
    dfs(r+1,c)
    dfs(r-1,c)
    dfs(r,c+1)
    dfs(r,c-1)
#(DFS)capture unsurrounded region(0->T)
for r in range(rows):
    for c in range(cols):
        if board[r][c]=="O" and (r==0 or r==rows-1 or c==0 or c==cols-1):
            dfs(r,c)
#capture surrounded region(0->x)
for r in range(1,rows-1):
    for c in range(1,cols-1):
        if board[r][c]=="O":
            board[r][c]="X" 
#uncapture unsurrounded region(T->0)
for r in range(rows):
    for c in range(cols):
        if board[r][c]=="T":
            board[r][c]="O"
```

{{< rawdetails title="visualization">}}
{{< carousel path="projects/leetcode-solutions/graphs/130/images/" >}}
{{< endrawdetails >}}


{{< endrawdetails >}}

