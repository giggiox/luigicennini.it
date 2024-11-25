{{< rawdetails title="136. Single Number" link="https://leetcode.com/problems/single-number/" 
	desc="projects/leetcode-solutions/general-problems/136/description.html">}}

```python
res = 0
for n in nums:
    res = n ^ res
return res
```

{{< endrawdetails >}}
