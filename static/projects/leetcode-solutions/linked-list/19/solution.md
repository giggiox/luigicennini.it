{{< rawdetails title="19. Remove Nth Node From End of List" link="https://leetcode.com/problems/remove-nth-node-from-end-of-list" >}}

```python
dummyNode = ListNode()
dummyNode.next = head
l = dummyNode
i = 0
r = dummyNode.next
while i < n:
    r = r.next
    i += 1
        
while r:
    l = l.next
    r = r.next
      
l.next = l.next.next
return dummyNode.next
```

{{< endrawdetails >}}