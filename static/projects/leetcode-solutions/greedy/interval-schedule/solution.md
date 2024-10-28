{{< rawdetails title="interval-schedule" >}}

Problem:
> Suppose you have a resource shared by many people and it can't be use in parallel. You have to maximize the number of task that can be done and return those tasks.
![](/projects/leetcode-solutions/greedy/interval-schedule/images/explanation.PNG)


Greedy algorithms are about choosing at each step the best solution possible, and never looking back.
But what is the best solution in the case of the "interval scheduling" problem?

1. I can choose the interval that starts first. But this one will lead to a non optimal solution.
![](/projects/leetcode-solutions/greedy/interval-schedule/images/0.PNG)

2. I can choose the shortest interval first. But this one will lead to a non optimal solution.
![](/projects/leetcode-solutions/greedy/interval-schedule/images/2.PNG)

3. I can choose the interval with the fewest conflicts. But this one will lead to a non optimal solution.
![](/projects/leetcode-solutions/greedy/interval-schedule/images/3.PNG)

4. I can choose the interval that ends first. This one will lead to a non optimal solution.



```python
procedure IntervalSchedule (1,2,...,n)
	candidate <- {1,2,...,n}
	out <- {}
	while candidate
		k <- interval that ends first
		out <- out U {k}
		candidate <- candidate - {k}
		remove from candidate all the intervals incompatible with k
	return out
```


And this is the implementation in python:

```python
intervals.sort(key = lambda x: x[1])
out = [intervals[0]]
t = intervals[0][1]
for i in range(1,len(intervals)):
    if intervals[i][0] >= t:
		out.append(intervals[i])
        t = intervals[i][1]
return out
```


{{< endrawdetails >}}


