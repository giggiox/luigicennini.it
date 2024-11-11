{{< rawdetails title="347. Top K Frequent Elements" link="https://leetcode.com/problems/top-k-frequent-elements/">}}

You can also solve this problem with heap, the solution with heap will have a complexity of $O(nlogk)$ while this solution is $O(n)$.

```python
n = len(nums)
counter = Counter(nums)
buckets = [0] * (n + 1)

for num, freq in counter.items():
	if buckets[freq] == 0:
		buckets[freq] = [num]
	else:
		buckets[freq].append(num)    
ret = []
for i in range(n, -1, -1):
	if buckets[i] != 0:
		ret.extend(buckets[i])
	if len(ret) == k:
		break
return ret
```
{{< endrawdetails >}}



