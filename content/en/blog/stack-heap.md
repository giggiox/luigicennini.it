---
title: "Stack & Heap"
date: 2025-02-15T19:53:33+05:30
draft: false
author: "Luigi"
tags:
  - Rich content
  - Sample
  - example
description: ""
toc: true
mathjax: true
---

{{< rawhtml >}} 
<script>
MathJax = {
	tex: {
		inlineMath: [["$", "$"]]
	}
};
</script>

<style>
pre {
  max-height: none !important;
  height: auto !important;
  overflow-y: visible !important;
}

.carousel-control-prev-icon,
.carousel-control-next-icon {
    background-color: black;
}

.carousel-indicators [data-bs-target] {
    background-color: #000; /* Colore degli indicatori (nero) */
    border-radius: 50%; /* Forma circolare */
    width: 10px; /* Larghezza dell'indicatore */
    height: 10px; /* Altezza dell'indicatore */
    opacity: 0.5; /* Trasparenza per indicatori non attivi */
    border: none; /* Rimuove il bordo quadrato */
}

.carousel-indicators [data-bs-target].active {
    opacity: 1; /* Opacità per l'indicatore attivo */
}

/* Posizionamento delle frecce */
.carousel-control-prev,
.carousel-control-next {
	margin-top: 40%;
    width: 5%; /* Regola la larghezza delle frecce */
}

.carousel-item {
    transition: none !important; /* Disabilita la transizione */
}

.carousel-item.active {
    display: block; /* Assicurati che l'immagine attiva sia mostrata */
}

.carousel-item-next,
.carousel-item-prev,
.carousel-item.active {
    display: block; /* Assicura che le immagini siano visibili */
}

.carousel-control-prev-icon {
    transform: rotate(90deg); /* Ruota di 90° in senso orario */
}

/* Ruota la freccia "avanti" verso il basso */
.carousel-control-next-icon {
    transform: rotate(90deg); /* Ruota di 270° in senso orario */
}


body img{
    filter: invert(100%);
    mix-blend-mode: difference;
    background-color: #18191A; /* Questo diventa il nuovo "bianco" */
}
.navbar-brand img{
	filter: none;
	mix-blend-mode: normal;
}

</style>


    
{{< /rawhtml >}}

While writing the [Why Java Strings Are Special](https://www.luigicennini.it/en/blog/java-strings/) post, I realized I didn't remember exactly how stack and heap really works. So I dug out my operating system notes and refreshed some good ol' memories.

Here we go, a deep dive into memory management in C!

# Memory layout of a C program
A C program's memory can be visualized as follows:

{{< includeImage path="/blog/stack-heap/3.png" >}}



The key parts are:
- `.text` - Stores the compiled machine code (read-only).
- `Data` section - split into:
	- Initialized data - Stores global and static variables with assigned values.
	- Uninitialized data - Stores global and static variables without assigned values.
- `Stack` - Stores function call frames, local variables, and grows downwards.
- `Heap` - Used for dynamic memory allocation, grows upwards.

*Note: This is a simplified representation of how a program appears in memory. In reality, the Memory Management Unit (MMU) handles all address translations for virtual memory. The CPU "spits" out a logical address which is translated by the MMU into a certain segment/page then allocated in the RAM. It can be worth investigating about virtual memory in another blog post though ;)*


Let's consider the following example:

```c
int a;
int b = 10;
int main () {
	int c = 10;
	return 0;
}
```

- `a` is an uninitialized global variable, so it goes into the uninitialized data section.
- `b` is an initialized global variable, so it is stored in the initialized data section.
- `c` is a local variable in `main()`, so it is stored in the stack frame of `main()`.



{{< includeImage path="/blog/stack-heap/5.png" >}}




## Allocating in stack and heap
By default, all variables are allocated on the stack. 
However, we can allocate memory on the heap using `malloc()`. Consider this example:
```c
#include <stdlib.h>

int main() {
    int a = 3;           // Stored in stack
    int b[] = {1, 2, 3}; // Stored in stack
    int *c = malloc(sizeof(int) * 3); // Allocated in heap
    return 0;
}
```


Before the function return statement, the stack will contain a and b, while c will store a pointer to the heap-allocated array.

{{< includeImage path="/blog/stack-heap/4.png" >}}

Notice how every varabile has an address in memory, even a pointer which is essentially a container for a memory address, still has it's own address.


## Passing by value vs by reference
Let's explore how function arguments behave when passed by value versus reference by taking this program as an example:

```c
#include <stdio.h>
#include <stdlib.h>

void foo(int val, int arr[]) {
    val = 11; // No effect on original value
    int a = 12;
    arr[0] = a; // Modifies the original array
    arr = {5, 6, 7}; // No effect on original array
}

int main() {
    int a = 3;
    int b[3] = {1, 2, 3};
    int *c = malloc(sizeof(int) * 3);
    foo(a, b);
    free(c);
    return 0;
}
```

You can see what happens step by step here below:

{{< carousel path="blog/stack-heap/carousel/" >}}

The key takeaways are:
- `val` is passed by value, meaning changes inside `foo` don't affect `a` in main.
- `arr` is passed as a pointer, so modifications to `arr[0]` affect `b[0]` in main.
- Assigning `arr` to a new array inside `foo()` only changes the local copy of arr, not the original pointer.



## Stack size and stack overflow
In Linux, you can check the stack size limit using:
```bash
ulimit -s
```

Or:
```bash
ulimit -a | grep "stack size"
```

The stack has a fixed size, which explains why a stack overflow occurs when a function recurses indefinitely. 
Consider this example:

```c
int foo (int a) {
	foo(a);
}

int main () {
	foo(5);
	return 0;
}
```

You can already imagine from the carousel above what is happening, but here you go again:
{{< carousel path="blog/stack-heap/stack-overflow/" >}}


## References
- Online memory stack and heap visualizer ([link](https://ryoskate.jp/PlayVisualizerC.js/))



Luigi