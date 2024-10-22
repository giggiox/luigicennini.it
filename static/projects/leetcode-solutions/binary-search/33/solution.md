{{< rawdetails title="33. Search in Rotated Sorted Array" link="https://leetcode.com/problems/search-in-rotated-sorted-array/" >}}

```python
l,r = 0,len(nums)-1
while l <= r:
    m = (l+r) //2
    if nums[m] == target:
        return m
    if nums[l] <= nums[m]: #left half is sorted
        if nums[l] <= target <= nums[m]:
            r = m-1
        else:
            l = m+1
    else:
        if nums[m] <= target <= nums[r]:
            l = m+1
        else:
            r = m-1
return -1
```



{{< endrawdetails >}}