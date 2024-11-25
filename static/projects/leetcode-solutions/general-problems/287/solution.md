{{< rawdetails title="287. Find the Duplicate Number" link="https://leetcode.com/problems/find-the-duplicate-number/" 
	desc="projects/leetcode-solutions/general-problems/287/description.html">}}

```python
slow,fast = 0,0
while True:
    slow = nums[slow]
    fast = nums[nums[fast]]
    if slow == fast:
        break
slow1 = 0
while True:
    slow1 = nums[slow1]
    slow = nums[slow]
    if slow1 == slow:
        return slow1
```

{{< endrawdetails >}}
