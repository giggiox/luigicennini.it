{{< rawdetails title="74. Search a 2D Matrix" link="https://leetcode.com/problems/search-a-2d-matrix/" >}}

```python
m = len(matrix)
n = len(matrix[0])
left, right= 0, m*n-1
while left <= right:
    mid = (left + right) // 2
    mid_row, mid_col = mid // n, mid % n
    if matrix[mid_row][mid_col] == target:
        return True
    elif matrix[mid_row][mid_col] < target:
        left = mid + 1     
    else:
		right = mid - 1
return False
```


{{< rawdetails title="visualization">}}
{{< carousel path="projects/leetcode-solutions/binary-search/74/images/" >}}
{{< endrawdetails >}}


{{< endrawdetails >}}