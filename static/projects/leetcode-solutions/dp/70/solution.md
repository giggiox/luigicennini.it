{{< rawdetails title="70. Climbing Stairs" link="https://leetcode.com/problems/climbing-stairs/" >}}

{{< rawdetails title="Naive DFS approach (TLE)" >}}
```python
def dfs(step):
	if step == 0:
		return 1
	if step < 0:
		return 0
	l = dfs(step - 1)
	r = dfs(step - 2)
	return l + r
return dfs(n)
```

It is important, in order to easier the next step (memoization) that each node returns a value.
For example you can do a code that works but recursive calls does not return any value, like this:
```python
res = []
def dfs(step):
	if step == 0:
		res[0] += 1
		return
	if step < 0:
		return
	dfs(step - 1)
	dfs(step - 2)
return dfs(n)	
```
But it will be difficult now to achive the momoization step, what do we save into the dictionary? Here the node *does not make any work*, so we can't save it's work.


{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/dp/70/naive/" >}}
Or look at the tree with [this link](https://www.recursionvisualizer.com/?function_definition=%0Adef%20dfs%28step%29%3A%0A%20%20if%20step%20%3D%3D%200%3A%0A%20%20%20%20return%201%0A%20%20if%20step%20%3C%200%3A%0A%20%20%20%20return%200%0A%20%20l%20%3D%20dfs%28step%20-%201%29%0A%20%20r%20%3D%20dfs%28step%20-%202%29%0A%20%20return%20l%20%2B%20r&function_call=dfs%285%29)
{{< endrawdetails >}}


{{< endrawdetails >}}


{{< rawdetails title="Dynamic Programming top-down (memoization)" >}}

```python
mem = {}
def dfs(step):
	if step in mem:
		return mem[step]
	if step == 0:
		return 1
	if step < 0:
		return 0
	l = dfs(step - 1)
	r = dfs(step - 2)
	mem[step] = l + r
	return l + r
return dfs(n)	
```

{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/dp/70/top-down/" >}}	
	
Or look at the tree with [this link](https://www.recursionvisualizer.com/?function_definition=mem%20%3D%20%7B%7D%0Adef%20dfs%28step%29%3A%0A%20%20if%20step%20in%20mem%3A%0A%20%20%20%20return%20mem%5Bstep%5D%0A%20%20if%20step%20%3D%3D%200%3A%0A%20%20%20%20return%201%0A%20%20if%20step%20%3C%200%3A%0A%20%20%20%20return%200%0A%20%20l%20%3D%20dfs%28step%20-%201%29%0A%20%20r%20%3D%20dfs%28step%20-%202%29%0A%20%20mem%5Bstep%5D%20%3D%20l%20%2B%20r%0A%20%20return%20l%20%2B%20r&function_call=dfs%285%29)
{{< endrawdetails >}}


{{< endrawdetails >}}


{{< rawdetails title="Dynamic Programming bottom-up (true dynamic programming)" >}}

The key to understand true dynamic programming is that we don't ask the question:
> i'm at the 5th step, what are the ways i can reach this step?

But you ask, progressively:
> i'm at the 5th step, what are the ways i can reach this step, *given that i know how to reach each step below*?

Now it is easier, because, to reach the 5th step, you can take 1 step from 4th step or 2 step from step 3 and you already know in how many ways you can reach both of them.

```python
df = [1] * (n+1)
for i in range(2,n + 1):
	df[i] = df[i-1] + df[i-2]
return df[n]
```
{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/dp/70/bottom-up/" >}}
{{< endrawdetails >}}


{{< endrawdetails >}}



{{< endrawdetails >}}