{{< rawdetails title="90. Subsets II" link="https://leetcode.com/problems/subsets-ii/"
	desc="projects/leetcode-solutions/backtrack/90/description.html">}}

```python
res = []
sub = []
nums.sort()
def backtrack(i):
    if i == len(nums):
        res.append(sub.copy())
        return
    sub.append(nums[i])
    backtrack(i+1)
    sub.pop()
    while i + 1 < len(nums) and nums[i] == nums[i + 1]:
        i += 1
    backtrack(i+1)
backtrack(0)
return res
```

{{< endrawdetails >}}
