{{< rawdetails title="sorting" >}}


{{< rawdetails title="selection sort" >}}
```python
def selection_sort(a):
    for i in range(0,len(a) - 1):
        minn = i
        for j in range(i+1, len(a)):
            if a[j] < a[minn]:
                minn = j
        a[minn], a[i] = a[i], a[minn]
```
{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/sorting/sorting/images/selection/" >}}
{{< endrawdetails >}}

{{< rawdetails title="time complexity" >}}
$$T(n) = O(n^2)$$

Because for $i=0$ we have $n-1$ comparisons, for $i=1$ we have $n-2$ comparisons, ..., for $i=n-2$ we have $1$ comparison.
The number of comparisons is then $ \sum_{i=0}^{n-1} i = \frac{n(n-1)}{2}$

{{< endrawdetails >}}

**Selection sort is NOT stable**.

{{< endrawdetails >}}


{{< rawdetails title="insertion sort" >}}
```python
def insertion_sort(a):
    for i in range(1, len(a)):
        v = a[i]
        j = i
        while j > 0 and a[j - 1] > v:
            a[j] = a[j - 1]
            j -= 1
        a[j] = v
```

{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/sorting/sorting/images/insertion/" >}}
{{< endrawdetails >}}


**Insertion sort IS stable**.
{{< endrawdetails >}}


{{< rawdetails title="bubble sort" >}}
```python
def bubble_sort(a):
    for i in range(len(a)-1, 0, -1):
        for j in range(1, i + 1):
            if a[j - 1] > a[j]:
                a[j - 1], a[j] = a[j], a[j - 1]
```



{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/sorting/sorting/images/bubble/" >}}
{{< endrawdetails >}}

{{< rawdetails title="time complexity" >}}
$$T(n) = O(n^2)$$

Because for $i=n-1$ we have $n-1$ comparisons, for $i=n-2$ we have $n-2$ comparisons, ..., for $i=1$ we have $1$ comparison.
The number of comparisons is then $ \sum_{i=0}^{n-1} i = \frac{n(n-1)}{2}$
{{< endrawdetails >}}


**Bubble sort IS stable**.


Slightly better algorithm with flag:

```python
def bubble_sort_flag(a):
    i = len(a) - 1
    sorted = False
    while i >= 1 and not sorted:
        sorted = True
        for j in range(1,i + 1):
            if a[j - 1] > a[j]:
                a[j - 1], a[j] = a[j], a[j - 1]
                sorted = False
        i = i - 1
```
{{< endrawdetails >}}



{{< rawdetails title="bucket sort" >}}
```python
def bucket_sort(arr):
    n = len(arr)
    buckets = [[] for _ in range(n)]
    for num in arr:
        bi = int(n * num)
        buckets[bi].append(num)
    for bucket in buckets:
        insertion_sort(bucket)
    index = 0
    for bucket in buckets:
        for num in bucket:
            arr[index] = num
            index += 1
arr = [0.78, 0.17, 0.39, 0.26, 0.72, 0.94, 0.21, 0.12, 0.23, 0.68]
```

You can use any stable algorithm to sort each bucket.

{{< rawdetails title="time complexity" >}}
$$T(n) = O(n^2)$$
{{< endrawdetails >}}


{{< endrawdetails >}}

{{< rawdetails title="heap sort" >}}
```python
import heapq

def heap_sort(arr):
    heapq.heapify(arr)
    result = []
    while arr:
        result.append(heapq.heappop(arr))
    return result
```

{{< rawdetails title="time complexity" >}}

Heapify complexity is $O(n)$, heappop complexity is $O(log_2n)$, hence:
$$T(n) = O(nlog_2n)$$
{{< endrawdetails >}}

**Heap sort is NOT stable**

{{< endrawdetails >}}



{{< rawdetails title="quick sort" >}}
```python
def partition(a, l, r):
    pivot = a[r]
    i, j  = l, r - 1
    while True:
        while a[i] < pivot:
            i += 1
        while a[j] > pivot and j > 0:
            j -= 1
        if i >= j:
            break
        a[i], a[j] = a[j], a[i]
    a[i], a[r] = a[r], a[i]
    return i

def quicksort(a, l, r):
    if l < r:
        pi = partition(a, l, r)
        quicksort(a, l, pi - 1)
        quicksort(a, pi + 1, r)
```

{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/sorting/sorting/images/quick/" >}}
{{< endrawdetails >}}

{{< rawdetails title="time complexity" >}}
- On the best case scenario, every partition divide the array in half
$$T(n) = 2T(\frac{n}{2}) + n$$
$$\rightarrow T(n) = O(nlog_2n)$$

- On the worst case scenario, the array is already sorted
$$T(n) = T(n-1) + n$$
$$\rightarrow T(n) = O(n^2)$$
 
- On the average case scenario, the array is already sorted
$$T(n) = \frac{1}{n} \sum_{k=1}^{n} (T(k-1) + T(n-k-1)) + n$$
$$\rightarrow T(n) = O(nlog_2n)$$


Because we have to sum every case a[0]|---k---| P |---(n-k-1)---|a[n-1] and get the average.
{{< endrawdetails >}}


**Quick sort is NOT stable**.
{{< endrawdetails >}}



{{< rawdetails title="merge sort" >}}
```python
def merge(a, l, m, r):
    n1 = m - l + 1
    n2 = r - m
    L = [0] * n1
    R = [0] * n2
    for i in range(n1):
        L[i] = a[l + i]
    for j in range(n2):
        R[j] = a[m + 1 + j]
       
    i, j, k = 0, 0, l
    while i < n1 and j < n2:
        if L[i] <= R[j]:
            a[k] = L[i]
            i += 1
        else:
            a[k] = R[j]
            j += 1
        k += 1
    
    while i < n1:
        a[k] = L[i]
        i += 1
        k += 1
    while j < n2:
        a[k] = R[j]
        j += 1
        k += 1

def mergesort(a, l, r):
    if l < r:
        m = (r + l) // 2
        mergesort(a, l, m)
        mergesort(a, m + 1, r)
        merge(a, l, m, r)
```

{{< rawdetails title="visualization" >}}
	{{< carousel path="projects/leetcode-solutions/sorting/sorting/images/merge/" >}}
{{< endrawdetails >}}

{{< rawdetails title="time complexity" >}}

$$T(n) = 2T(\frac{n}{2}) + n$$
$$\rightarrow T(n) = O(nlog_2n)$$
{{< endrawdetails >}}

**Merge sort IS stable**.

{{< endrawdetails >}}





{{< rawdetails title="sorting in python" >}}
```python
a = [6, 9, 2, 9, 90, 18]
a.sort() # -> [2, 6, 9, 9, 18, 90]
```

You can also use `sorted` like this
```python
a = [6, 9, 2, 9, 90, 18]
a = sorted(a) # -> [2, 6, 9, 9, 18, 90]
```

The catch with sorted is that it can be used to sort tuples while `tuple.sort()` won't work
```python
a = (6, 9, 2, 9, 90, 18)
# a.sort() # a is not an array
a = sorted(a) # now a will be a sorted array
```

If the array is made of tuple it will always sort by the first element of the tuple:
```python
a = [(6, 9), (2, 100), (9, 77), (90, 99), (18, 89)]
a.sort() # -> [(2, 100), (6, 9), (9, 77), (18, 89), (90, 99)]
```

You can specify how to sort the array with the key parameter.
E.g you want the array to be sorted in reverse:
```python
a = [6, 9, 2, 9, 90, 18]
a.sort(key = lambda x: -x) # same as a.sort(reverse = True)
```

Same thing for the sorted method.


key parameter can also be used to specify how to order in case we have a matching in the first tuple element:
```python
a = [(6, 9), (2, 100), (9, 77), (9, 99), (90, 99), (18, 89)]
a.sort(key = lambda x: (x[0],- x[1])) # -> [(2, 100), (6, 9), (9, 99), (9, 77), (18, 89), (90, 99)]
```

In this case we have a matching in the tuple (9,77), (9,99) and it is sorted decreasingly for the second element of the tuple.


{{< endrawdetails >}}



{{< endrawdetails >}}