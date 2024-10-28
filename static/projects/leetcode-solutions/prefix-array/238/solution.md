{{< rawdetails title="238. Product of Array Except Self" link="https://leetcode.com/problems/product-of-array-except-self/" >}}

```python
n = len(nums)
pref, suff = [1]*(n+1),[1]*(n+1)
for i in range(1,n+1):
	pref[i] = pref[i-1]*nums[i-1]
for i in range(n-1,-1,-1):
	suff[i] = suff[i+1] * nums[i]
out = []
for i in range(n):
	out.append(pref[i]*suff[i+1])
return out
```

{{< endrawdetails >}}
