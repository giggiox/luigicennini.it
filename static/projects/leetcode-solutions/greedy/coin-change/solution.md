{{< rawdetails title="coin change" >}}

Time complexity of the coin change problem (see 322. Coin Change) is 
$$ O(n*k) $$

**IF** you have a canonical coin set you can use a fully greedy approach. Note that to identify if a coin set is canonical there is a $O(n^3)$ algorithm.
In the case of problem 322 the testcase does not always have a canonical coin system, so we have to use a bruteforce approach (which is dynamic programming).

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

Take for example this coin set:

$coins = \[150,90,90,20,10\]$

$change = 180$


In this case the solution from the greedy algorithm is:

$S(greedy) = \[150,20,10\]$

But it's not the optimal one, which is:

$S(optimal) = \[90,90\]$

The optimal one is the one returned by the dynamic programming algorithm.






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
