{{< rawdetails title="206. Reverse Linked List" link="https://leetcode.com/problems/reverse-linked-list/" 
	desc="projects/leetcode-solutions/linked-list/206/description.html" >}}
```python
newList = None
while head:
	next = head.next
	head.next = newList
	newList = head
	head = next
return newList
```

{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/linked-list/206/images/" >}}
{{< endrawdetails >}}


{{< endrawdetails >}}