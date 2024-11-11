{{< rawdetails title="1636. Sort Array by Increasing Frequency" link="https://leetcode.com/problems/sort-array-by-increasing-frequency/">}}
```python
count = Counter(nums)
nums.sort(key=lambda x: (count[x],-x))
return nums
```
{{< endrawdetails >}}