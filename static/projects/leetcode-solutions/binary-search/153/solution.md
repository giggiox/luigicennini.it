{{< rawdetails title="153. Find Minimum in Rotated Sorted Array" link="https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/" >}}

```python
l, r = 0,len(nums)-1
while l < r:
    m = (l+r) // 2
    if nums[m] > nums[r]:
        l = m+1
    else:
        r = m
return nums[l]
```

{{< rawdetails title="visualization">}}
{{< carousel path="projects/leetcode-solutions/binary-search/153/images/" >}}
{{< endrawdetails >}}



{{< endrawdetails >}}