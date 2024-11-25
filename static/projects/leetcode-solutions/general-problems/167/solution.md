{{< rawdetails title="167. Two Sum II - Input Array Is Sorted" link="https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/" tag="2 pointers"
	desc="projects/leetcode-solutions/general-problems/167/description.html">}}

```python
l, r = 0, len(numbers)-1
while l < r:
    two_sum = numbers[l] + numbers[r]
    if two_sum < target:
        l += 1
    elif two_sum > target:
        r -= 1
    else:
        return [l+1,r+1]
```
{{< endrawdetails >}}