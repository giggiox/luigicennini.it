{{< rawdetails title="21. Merge Two Sorted Lists" link="https://leetcode.com/problems/merge-two-sorted-lists/" 
	desc="projects/leetcode-solutions/linked-list/21/description.html" >}}

```python
newList = ListNode()
tail = newList
while list1 != None and list2 != None:
    if list1.val < list2.val:
        tail.next = list1
        list1 = list1.next
    else:
        tail.next = list2
        list2 = list2.next
        tail = tail.next
if list1 != None:
	tail.next = list1
elif list2 != None:
	tail.next = list2 
return newList.next
```

{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/linked-list/21/images/" >}}
{{< endrawdetails >}}


{{< endrawdetails >}}

