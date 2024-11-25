{{< rawdetails title="1. Two Sum" link="https://leetcode.com/problems/two-sum/"
	desc="projects/leetcode-solutions/general-problems/1/description.html">}}

```python
d = {}
for i in range(len(nums)):
    if target-nums[i] in d:
        return [d[target-nums[i]],i]
    d[nums[i]] = i
```
{{< endrawdetails >}}