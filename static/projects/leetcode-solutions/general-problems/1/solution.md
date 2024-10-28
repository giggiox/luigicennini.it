{{< rawdetails title="1. Two Sum" link="https://leetcode.com/problems/two-sum/">}}

```python
d = {}
for i in range(len(nums)):
    if target-nums[i] in d:
        return [d[target-nums[i]],i]
    d[nums[i]] = i
```
{{< endrawdetails >}}