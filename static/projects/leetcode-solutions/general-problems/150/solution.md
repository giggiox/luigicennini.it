{{< rawdetails title="150. Evaluate Reverse Polish Notation" link="https://leetcode.com/problems/evaluate-reverse-polish-notation">}}

```python
stack = []
if len(tokens) == 1:
	return int(tokens[0])
for token in tokens:
	if token not in ['+','-','*','/']:
		stack.append(token)
	else:
		a, b = int(stack.pop()), int(stack.pop())
		if token == '+':
			stack.append(b + a)
		if token == '-':
			stack.append(b - a)
		if token == '/':
			stack.append(int(b / a))
		if token == '*':
			stack.append(b * a)
return stack[0]
```


{{< endrawdetails >}}
