{{< rawdetails title="136. Single Number" link="https://leetcode.com/problems/single-number/" >}}

```python
res = 0
for n in nums:
    res = n ^ res
return res
```

{{< endrawdetails >}}
