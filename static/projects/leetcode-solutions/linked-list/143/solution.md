{{< rawdetails title="143. Reorder List" link="https://leetcode.com/problems/reorder-list/" 
	desc="projects/leetcode-solutions/linked-list/143/description.html">}}

```python
# find middle
slow, fast = head, head.next
while fast and fast.next:
    slow = slow.next
    fast = fast.next.next

# reverse second half
second = slow.next
prev = slow.next = None
while second:
    tmp = second.next
    second.next = prev
    prev = second
    second = tmp

# merge two halfs
first, second = head, prev
while second:
    tmp1, tmp2 = first.next, second.next
    first.next = second
    second.next = tmp1
    first, second = tmp1, tmp2
```


{{< endrawdetails >}}

