{{< rawdetails title="207. Course Schedule" link="https://leetcode.com/problems/course-schedule/" tag="cycle detection or cycle detection with BFS topo sort">}}

```python
adjList = defaultdict(list)
for e in prerequisites:
    adjList[e[1]].append(e[0])

states = [0] * numCourses
def dfs(i):
    if states[i] == 2:
        return True
    states[i] = 1
    for v in adjList[i]:
        if states[v] == 1:
            return False
        a = dfs(v)
        if not a:
            return False
    states[i] = 2
    return True

for i in range(numCourses):
    if not dfs(i):
        return False
return True
```

{{< rawdetails title="visualization">}}
{{< carousel path="projects/leetcode-solutions/graphs/207/images/" >}}
{{< endrawdetails >}}


{{< rawdetails title="using topological sort">}}
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
        
return len(out) == numCourses
```
{{< endrawdetails >}}


{{< endrawdetails >}}

