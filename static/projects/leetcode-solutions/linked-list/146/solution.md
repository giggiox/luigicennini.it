{{< rawdetails title="146. LRU Cache" link="https://leetcode.com/problems/lru-cache/" 
	desc="projects/leetcode-solutions/linked-list/146/description.html">}}

```python
class LRUCache:

    def __init__(self, capacity: int):
        self.capacity = capacity
        self.cache = {}    
        self.lru = Node(0,0)
        self.mru = Node(0,0)
        self.lru.next = self.mru
        self.mru.prev =  self.lru

    def get(self, key: int) -> int:
        if key in self.cache:
            self.remove(self.cache[key])
            self.insert(self.cache[key])
            return self.cache[key].value
        return -1
        
    def put(self, key: int, value: int) -> None:
        if key in self.cache:
            self.remove(self.cache[key])
        self.cache[key] = Node(key,value)
        self.insert(self.cache[key])

        if len(self.cache) > self.capacity:
            #remove and delete the LRU
            lru = self.lru.next
            self.remove(lru)
            del self.cache[lru.key]
        
	# Removes any node from linked list in O(1)
    def remove(self, node):
        prev,next = node.prev,node.next
        prev.next,next.prev = next,prev

	# Inserts new node from mru
    def insert(self,node):
        prev,next = self.mru.prev, self.mru
        prev.next = next.prev = node
        node.next, node.prev = next,prev
```


{{< rawdetails title="visualization">}}
{{< carousel path="projects/leetcode-solutions/linked-list/146/images/" >}}
{{< endrawdetails >}}

{{< endrawdetails >}}