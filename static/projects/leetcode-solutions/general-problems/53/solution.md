{{< rawdetails title="53. Maximum Subarray (sum)" link="https://leetcode.com/problems/maximum-subarray/" tag="kadane's algorithm"
	desc="projects/leetcode-solutions/general-problems/53/description.html">}}



{{< rawdetails title="naive solution">}}
```python
currMax = nums[0] #not 0 because array can be all negative
for i in range(len(nums)):
    currSum = 0
    for j in range(i,len(nums)):
        currSum += nums[j]
        currMax = max(currMax, currSum)
return currMax
```
{{< endrawdetails >}}

{{< rawdetails title="Kadane’s Algorithm">}}
```python
currMax = nums[0]
globalMax = nums[0]
for i in range(1,len(nums)):
    currMax = max(nums[i],currMax + nums[i])
    globalMax = max(globalMax, currMax)
return globalMax
```
{{< endrawdetails >}}


{{< endrawdetails >}}