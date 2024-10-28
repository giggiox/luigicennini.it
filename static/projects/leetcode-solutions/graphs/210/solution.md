{{< rawdetails title="210. Course Schedule II" link="https://leetcode.com/problems/course-schedule-ii/" tag="topological sort">}}

```python
adj_list = defaultdict(list)
for p in prerequisites:
    adj_list[p[1]].append(p[0])
        
in_degrees = [0] * numCourses
for p in prerequisites:
    in_degrees[p[0]] += 1
        
q = deque()
for i in range(numCourses):
    if in_degrees[i] == 0:
        q.append(i)
out = []
while q:
    v = q.popleft()
    out.append(v)
    for n in adj_list[v]:
        in_degrees[n] -= 1
        if in_degrees[n] == 0:
            q.append(n)
if len(out) == numCourses:
    return out
else:
    return []
```

{{< endrawdetails >}}

