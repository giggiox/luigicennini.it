{{< rawdetails title="704. Binary Search" link="https://leetcode.com/problems/binary-search/" >}}

```python
l,r = 0,len(nums)-1
while l<=r:
    m = (l+r) // 2
    if nums[m] == target:
        return m
    if nums[m] > target:
        r = m - 1
    else:
        l = m + 1
return -1
```

{{< rawdetails title="visualization">}}
{{< carousel path="projects/leetcode-solutions/binary-search/704/images/" >}}
{{< endrawdetails >}}

{{< endrawdetails >}}