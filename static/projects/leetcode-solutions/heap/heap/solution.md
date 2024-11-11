{{< rawdetails title="heap">}}

A heap is an array `arr` where the following relationship

$$\forall i \in [1,n/2], arr[i] > arr[2i], arr[i] > arr[2i + 1]$$

holds.

```python
class Heap:
    @staticmethod
    def heapify(arr):
        """Transform the arr to a min-heap"""
        n = len(arr)
        # Applica heapify_down a partire dall'ultimo nodo non foglia fino alla radice
        for i in range(n // 2 - 1, -1, -1):
            MinHeap._heapify_down(arr, n, i)

    @staticmethod
    def heappush(arr, value):
        """Adds value to the heap while keeping the heap property"""
        arr.append(value)
        MinHeap._heapify_up(arr, len(arr) - 1)

    @staticmethod
    def heappop(arr):
        """Remove and returns heap smallest element"""              
        root = arr[0]
        # Sostituisce la radice con l'ultimo elemento e riduce la dimensione dell'array
        arr[0] = arr[-1]
        arr.pop()
        
        # Riordina l'heap
        MinHeap._heapify_down(arr, len(arr), 0)
        return root

    @staticmethod
    def _heapify_down(arr, n, i):
        """Keep the min-heap property starting from position i going down in the tree"""
        while True:
            smallest = i
            left = 2 * i + 1   # Figlio sinistro
            right = 2 * i + 2  # Figlio destro
            
            # Se il figlio sinistro esiste e il suo valore è minore di quello del nodo corrente
            if left < n and arr[left] < arr[smallest]:
                smallest = left
            
            # Se il figlio destro esiste e il suo valore è minore di quello del nodo corrente
            if right < n and arr[right] < arr[smallest]:
                smallest = right
            
            # Se il nodo corrente non è il più piccolo, scambia e continua la discesa
            if smallest != i:
                arr[i], arr[smallest] = arr[smallest], arr[i]
                i = smallest
            else:
                break

    @staticmethod
    def _heapify_up(arr, i):
        """Keep the min-heap property starting from position i going up in the tree"""
        while i != 0 and arr[(i - 1) // 2] > arr[i]:
            parent = i // 2
            arr[i], arr[parent] = arr[parent], arr[i]
            i = parent
```


In python this class is implemented in the `heapq` library.

| method           | time complexity      |
|-------------------------------|-----------|
| heapq.heapify(arr)            | $O(n)$      |
| heapq.heppush(arr, element)   | $O(log_2n)$ |
| heapq.heappop(arr)            | $O(log_2n)$ |





{{< endrawdetails >}}



