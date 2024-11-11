{{< rawdetails title="1046. Last Stone Weight" link="https://leetcode.com/problems/last-stone-weight/">}}

```python
hp = []
for i in range(len(stones)):
	hp.append(-1*stones[i])
heapq.heapify(hp)
        
while len(hp) > 1:
	x = heapq.heappop(hp)
	y = heapq.heappop(hp)
	if x != y:
		heapq.heappush(hp,-abs(x-y))

if len(hp) == 0:
	return 0
return -1*hp[0]
```


{{< endrawdetails >}}



