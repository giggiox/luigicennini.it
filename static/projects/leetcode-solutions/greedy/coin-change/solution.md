{{< rawdetails title="coin change" >}}

Time complexity of the coin change problem (see 322. Coin Change) is 
$$ O(N*K) $$

**IF** you have a canonical coin set (\*) you can use a fully greedy approach.
In the case of problem 322 the testcase does not always have a canonical coin system, so we have to use a bruteforce approach (which is dynamic programming).

The greedy choiche in this case is choosing at each step the largest coin that is less than the change.
The pseudo-code of the algorithm is the following:
```python
def coinChange(change, coins):
	S = {}
	while change > 0:
		c = largest coins[i]: coins[i] <= r
		if no such c:
			return no solution
		change = change - c
		S = S + {c}
	return S
```


In python the code is:

```python
def coinChange(change, coins):
	out = []
	coins.sort()
	while r > 0 and coins:
		c = coins.pop()
		if c >= change:
			change = change - c
			out.append(c)
	if r == 0:
		return out
	else:
		return no solution
```

The algorithm requires a sort so:

$$T(n) \in O(nlogn)$$

{{< endrawdetails >}}
