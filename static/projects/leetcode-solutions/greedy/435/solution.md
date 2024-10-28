{{< rawdetails title="435. Non-overlapping Intervals" link="https://leetcode.com/problems/non-overlapping-intervals/">}}

See the solution for interval-schedule, this algorithm is exactly that one but with a twist, here we don't ask to return the right intervals but the number of intervals that are left out.


```python
intervals.sort(key = lambda x: x[1])
t = intervals[0][1]
out = 0
for i in range(1,len(intervals)):
    if intervals[i][0] >= t:
        t = intervals[i][1]
    else:
        out += 1
return out
```


{{< endrawdetails >}}


