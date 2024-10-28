{{< rawdetails title="15. 3Sum" link="https://leetcode.com/problems/3sum/">}}

```python
nums.sort()
out = []
for i in range(len(nums)-2):
    if i > 0 and nums[i] == nums[i-1]:
        continue
    l, r = i+1,len(nums)-1
    while l < r:
        t_sum = nums[i] + nums[l] + nums[r]
        if t_sum < 0:
            l += 1
        elif t_sum > 0:
            r -= 1
        else:
            triplets = [nums[i],nums[l],nums[r]]
            out.append(triplets)
            while l < r and nums[l] == triplets[1]:
                l += 1
            while r > l and nums[r] == triplets[2]:
                r -= 1
return out
```
{{< endrawdetails >}}


