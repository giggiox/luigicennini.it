---
title: "CUDA k-means"
date: 2025-02-08T19:53:33+05:30
draft: false
author: "Luigi"
tags:
  - Rich content
  - Sample
  - example
image: /projects/cuda-kmeans/back.png
description: ""
toc: true
mathjax: true
---


{{< rawhtml >}}

<style>
.tooltip-inner {
	text-align: left;
    white-space: pre-line;
	max-width: 30em;
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



/* Stile per il tag <summary> */
summary {
  font-weight: bold; /* Testo in grassetto */
  cursor: pointer; /* Mostra il cursore come una mano */
  padding: 5px; /* Spaziatura interna */
  list-style: none; /* Rimuovi lo stile predefinito del marker */
}

/* Aggiungi una freccia per indicare lo stato chiuso */
summary::marker {
  content: "▶ "; /* Freccia orientata verso destra */
}

/* Stile per <summary> quando il <details> è aperto */
details[open] > summary::marker {
  content: "▼ "; /* Freccia orientata verso il basso */
}



details {
  border-radius: 5px;
  // margin-left: 20px;
}

details details {
  margin-left: calc(20px * 1);
}

details details details {
  margin-left: calc(20px * 2);
}

canvas {
	background-color: #f8f9fa;
    width: 100%;
    height: auto;
    max-width: 500px; /* Mantieni una dimensione massima */
    display: block; 
}

body.d-mode canvas{
	background-color: #212529;
}



pre {
  max-height: none !important;
  height: auto !important;
  overflow-y: visible !important;
}

.no-invert {
	filter: none !important;
}

.featured-image img {
    filter: none !important;
	clip-path: inset(0px) !important;
}

.navbar-brand img {
	filter: none !important;
	clip-path: inset(0px) !important;
}

body.l-mode img {
	clip-path: inset(4px);
}
body.d-mode img{
	clip-path: inset(4px); /* Ritaglia 10px di bordo */
	filter: invert(1) hue-rotate(180deg);
}



.custom-toc {
  border-left: 3px solid #007bff;
  padding-left: 10px;
  font-size: 14px;
}

.custom-toc h3 {
  margin-bottom: 5px;
  font-size: 16px;
  color: #333;
}

.custom-toc a {
  text-decoration: none;
  color: #007bff;
}

.custom-toc a:hover {
  text-decoration: underline;
}


</style>
<script>
MathJax = {
	tex: {
		inlineMath: [["$", "$"]]
	}
};



var isDarkMode = document.body.className.includes("dark");
document.body.classList.toggle('d-mode', isDarkMode);
document.body.classList.toggle('l-mode', !isDarkMode);
</script>

{{< /rawhtml >}}



Lately, I've been exploring GPU programming with CUDA by implementing the K-Means clustering algorithm. 
Below is a overview of my approach and some insights into the CUDA implementation.

You can find the source code of everyhting that is going to be discussed at this [link](https://github.com/giggiox/CUDA-kmeans).
{{< custom-toc >}}

# K-Means Algorithm
K-Means is an unsupervised classification algorithm that groups objects into k clusters based on their features. The algorithm consists of two main steps repeated until convergence:
1. **Assignment Step**: Assign each point to the nearest centroid.
2. **Update Step**: Update each centroid to be the mean of all points assigned to it.

A simplified pseudo-code:
```java
initialize centroids randomly.
for iteration = 1 to MAX_ITER:
	a. for each point:
		assign the point to its nearest centroid.
	b. for each centroid:
		update its position to be the mean of all assigned points.
```


Formally, we have $(x_1,...,x_n), x_i \in \mathbb{R}^d$ (data points). The k-means algorithm builds $k$ groups (or clusters) $S = \set{S_1,...,S_k}$ where the sum of the distances of the data points (SSE or Sum of Squared Error) to its centroid is minimized.
So the algorithm minimizes:
$$SSE = \sum_{i=1}^{k} \sum_{x_j \in S_i} dist(x_j, \mu_i)^2$$

$$\frac{\partial E}{\partial \mu_i} = 0 \implies \mu_i^{(t+1)} = \frac{1}{|S_i^{(t)}|} \sum_{x_j \in S_i^{(t)}} x_j$$

So the solution is to take each group element average as a new centroid (as per step (**b**)).
The relationship holds because in the differentiation we used **euclidean distance** as a distance function, different centroid updates can be found by changing the distance metric.




If you did not had the opportunity to look at how K-means works, i think the visualization below will give you a good grasp:

{{< rawhtml >}}
  <center>
	  <div class="section">
		<button id="initBtn1">Initialize Centroids</button>
		<button id="updateSeqBtn1">Sequential Iteration</button>
		<br><br>
		<canvas id="canvas1" width="500" height="500"></canvas>
	  </div>
  </center>
{{< /rawhtml >}}

*Note: Although the centroids are initialized randomly here, this isn't the optimal approach. If the starting centroids are poorly chosen, the final clusters may be incorrect. A better method is [kmeans++](https://en.wikipedia.org/wiki/K-means%2B%2B).*

# Parallelizing K-Means with CUDA

The most time-consuming part of K-Means is the assignment step (a), where we compute the distance from each point to every centroid. 
This part is a (what so called) [embarrassingly parallel](https://en.wikipedia.org/wiki/Embarrassingly_parallel) problem and can be accelerated with CUDA.
The update step (b) is a bit more involved because it requires careful handling to avoid race conditions when updating centroids.

## CUDA Kernel presentation
Here's the core CUDA code that handles both the assignment and update steps:
```cpp
__global__ void centroidAssignAndUpdate(float *dataPoints_dev,  float *centroids_dev, float *newCentroids_dev, int *clusterCardinality_dev,int*clusterLabel_dev, int N){
    const int index = threadIdx.x + blockIdx.x * blockDim.x;
    if (index >= N) return;
    int localIndex = threadIdx.x;
    __shared__ float newCentroids_shared[2 * K];
    __shared__ int clusterCardinality_shared[K];

    for (int i = localIndex; i < 2*K; i += blockDim.x) {
        newCentroids_shared[i] = 0.0;
        if (i < K) {
            clusterCardinality_shared[i] = 0;
        }
    }

    __syncthreads();
    float minDistance = INFINITY;
    int clusterLabel = 0;
    for (int j = 0; j < K; ++j) {
        float distance = distanceMetric(dataPoints_dev[index * 2], dataPoints_dev[index * 2 + 1],
                                        centroids_dev[j * 2], centroids_dev[j * 2 + 1]);
        if (distance < minDistance){
            minDistance = distance;
            clusterLabel = j;
        }
    }
    clusterLabel_dev[index] = clusterLabel;
    atomicAdd(&(newCentroids_shared[clusterLabel*2]), dataPoints_dev[index*2]);
    atomicAdd(&(newCentroids_shared[clusterLabel*2 + 1]), dataPoints_dev[index*2 + 1]);
    atomicAdd(&(clusterCardinality_shared[clusterLabel]),1);
    __syncthreads();

    for (int i = localIndex; i < K; i+= blockDim.x) {
        atomicAdd(&(newCentroids_dev[i*2]), newCentroids_shared[i*2]);
        atomicAdd(&(newCentroids_dev[i*2+1]), newCentroids_shared[i*2+1]);
        atomicAdd(&(clusterCardinality_dev[i]), clusterCardinality_shared[i]);
    }
}
```

If you are not already comfortable with CUDA code, the code above might be difficult to understand at first 😓.
Do not worry though! I will try to explain at my best what that code does.
To understand how it works, you have to first understand how a nvidia GPU works.


## Understanding the GPU Execution Model

A kernel is the function that runs on the GPU. 
When you launch a kernel, it is executed by a grid of blocks, where each block contains many threads. 
Threads within the same block can communicate using fast shared memory, which is essential for many parallel algorithms.

{{< includeImage path="/projects/cuda-kmeans/1.png">}}

The key parts are:
- Grid: A grid is a collection of blocks that execute your kernel. The grid can be one- (like in the picture above), two-, or three-dimensional, depending on the problem.
- Block: Each block is a group of threads that run concurrently and can share data via shared memory. Blocks are independent of each other.
- Thread: A thread is the smallest unit of execution. Each thread has access to a set of built-in variables that provide its unique identifiers, like `threadIdx.x` (thread's index within its block), `blockIdx.x` ( block's index within the grid) and `blockDim.x` (total number of threads in each block).


## CUDA Kernel explanation

Let's say our dataset is composed of 4 datapoints and we are performing $2$-means:

$$D = \set{x0,x1,x2,x3}$$
where
$$x0=(0,0), x1=(0,1)$$
$$x2=(1,0), x3 = (1,1)$$

And after the random centroids initialization (first step of the k-means algorithm) we find that

$$c0 = (0.5,0), c1 = (0.5,1)$$


We organize the data in a [Structure of Arrays (SoA)](https://en.wikipedia.org/wiki/AoS_and_SoA) layout because it stores similar types of data contiguously in memory. 
This arrangement improves cache utilization and enables more efficient vectorized and parallel memory access, which is particularly advantageous for GPU processing compared to the traditional Array of Structures (AoS) layout.

$$\text{points\_dev } = [x0, x1, x2, x3]$$ 
$$= [x0.x, x0.y, x1.x, x1.y, x2.x, x2.y, x3.x, x3.y]$$
$$= [0, 0, 0, 1, 1, 0, 1, 1]$$

And the same thing for the centroids:

$$\text{centroids\_dev } = [c0, c1]$$ 
$$= [0.5, 0, 0.5, 1]$$



### Calling the kernel

The kernel you have seen in the previous section performs one iteration of the k-means algorithm.
The kernel must be able to spawn at least one thread for each points, this will allow parallelism.
In the example above, it must spawn at least 4 threads.
Knowing that the number of threads per block is a fixed number (up to $1024$ for GPU's [with compute capability 2.x and higher](https://en.wikipedia.org/wiki/Thread_block_(CUDA_programming))), we must play with the number of blocks.

In the example above if we fix the number of thread per block to 2, we must set the number of blocks to 2.
We will call 

$$\text{kernelExample<<2,2>>(...)}$$

The kernel code can be broke down into 4 parts:

### Part 1: initializing shared memory
In this part we ensure each block has it's own copy of the centroids coordinates and that they are initialized to zero.
We must also have a block shared cluster cardinality vector to save the cardinality of each cluster.

{{< includeImage path="/projects/cuda-kmeans/2.png" >}}



The code to do that is the following:
```cpp
__shared__ float newCentroids_shared[2*K];
__shared__ int clusterCardinality_shared[K];

for(int i = threadIdx.x; i < 2*K; i += blockDim.x) {
	newCentroids_shared[i] = 0.0;
	if (i < K) {
		clusterCardinality_shared[i] = 0;
	}
} 
```
In CUDA, \_\_shared\_\_ variables have block-level scope, and there is no built-in function (like `memset`) to initialize shared memory. 
Therefore, you must manually zero out these arrays using a loop. 
The code above ensures that every element of the two shared arrays is set to zero before any further computation. 
It uses a strided loop so that if the number of threads per block (i.e., blockDim.x) is less than the total number of elements to initialize (2*K), each thread will initialize multiple elements.



#### An alternative approach
If you know that the number of threads per block is at least $2*K$, you could simplify the initialization using conditional statements:

```cpp
__shared__ float newCentroids_shared[2*K];
__shared__ int clusterCardinality_shared[K];

if (threadIdx.x < 2*K){
	newCentroids_shared[threadIdx.x] = 0.0;
}
if (threadIdx.x < K) {
	clusterCardinality_shared[i] = 0;
}
```

**Caveat:** Using this alternative method restricts you to a maximum of $K = blockDim.x / 2$ clusters. 
For example, if you use blocks of $1024$ threads, this approach limits you to at most $512$ clusters. 
The first method with the loop is more general, as it will correctly initialize the arrays even when $\text{THREAD\_PER\_BLOCK} < 2*K$.



#### The use of static shared memory

Both static variables are being statically allocated (the amount to be allocated is known at compile time).
Shared memory is not infinite, and depending on the GPU model can be 48KB=49152bytes or 16KB=16384bytes.

To be sure we are not allocating too much data, it is possible to clalculate the maximum number of centroids we can have:

Since the kernel `centroidAssignAndUpdate` has 2 shared arrays
1. `newCentroids_shared[2*K]`, which occupies $K\*2\* \text{ sizeof(float)}=K\*8 \text{ bytes}$

2. `clusterCardinality_shared[K]`, which occupies $K\*\text{ sizeof(int)}=K\*4 \text{ bytes}$
	
	
So in total with $K=100$ we are occupying $1200$ bytes of shared memory **per block**.


We can then calculate what is the maximum number of $K$ we can have.
If we know the size of GPU shared memory is 48kb=49152bytes, then  the maximum $K$ can be calculated as follows:

$$(2K\times 4) + (K\times 4) \leq 49152$$
$$12K \leq 49152$$ 
$$ K \leq 4096$$

So the maximum number of centroids we can have with this implementation is $4096$.


To check the block shared memory size, you can use this code:
```cpp
cudaDeviceProp prop;
cudaGetDeviceProperties(&prop, 0);
std::cout << "Shared Memory per Block: " << prop.sharedMemPerBlock << " bytes" << std::endl;
```


We can think about one optimization where we save cluster labels in a short int instead of a int, because we see that by doing so we get that the maximum number of $K$ is:
$$(2K\times 4) + (K\times 2) \leq 49152$$
$$K \leq 4915$$
While $4915$ still fits in a short int type.



---

After initializing the shared memory, a barrier is necessary:

```cpp
__syncthreads();
```
This synchronization ensures that every thread in the block has finished initializing the shared arrays before any thread begins subsequent computations. Without this barrier, some threads might access shared memory that hasn't been fully initialized, leading to race conditions and incorrect results.


### Part 2: assigning closer centroid
 
In this section we perform the "true parallel computation" of the K-means assignment step. For each data point, we compute the distance to every centroid and determine which centroid is closest. 
 
{{< includeImage path="/projects/cuda-kmeans/3.png" >}}

The code snippet below illustrates this process: 

```cpp
float minDistance = INFINITY;
int clusterLabel = 0;
for (int j = 0; j < K; ++j) {
	float distance = distanceMetric(dataPoints_dev[index*2],dataPoints_dev[index*2+1],
									centroids_dev[j*2],centroids_dev[j*2+1]);
	if(distance < minDistance){
		minDistance = distance;
		clusterLabel = j;
	}
}
clusterLabel_dev[index] = clusterLabel;
```

In the example we found that:
- $dist(x0,c0) < dist(x0,c1)$, so we assign $c0$ to $x0$
- $dist(x1,c0) > dist(x1,c1)$, so we assign $c1$ to $x1$
- $dist(x2,c0) < dist(x2,c1)$, so we assign $c0$ to $x2$
- $dist(x3,c0) > dist(x3,c1)$, so we assign $c1$ to $x3$


### Part 3: updating shared memory

In this section, we update the shared memory arrays with the results computed in step 2. 
Each thread adds its own data point's coordinates to the corresponding centroid's accumulator in shared memory.

{{< includeImage path="/projects/cuda-kmeans/4.png" >}}


In the example:
- $dist(x0,c0) < dist(x0,c1)$, so we update newCentroids_shared[0] with $x0.x$ and newCentroids_shared[1] with $x0.y$
- $dist(x1,c0) > dist(x1,c1)$, so we update newCentroids_shared[2] with $x1.x$ and newCentroids_shared[3] with $x1.y$
- $dist(x2,c0) < dist(x2,c1)$, so we update newCentroids_shared[0] with $x2.x$ and newCentroids_shared[1] with $x2.y$
- $dist(x3,c0) > dist(x3,c1)$, so we update newCentroids_shared[2] with $x3.x$ and newCentroids_shared[3] with $x3.y$

Because several threads within the same block might update the same centroid accumulator concurrently, this update phase is susceptible to race conditions. 
To avoid this, we use `atomicAdd` to ensure that each update is performed safely.

```cpp
atomicAdd(&(newCentroids_shared[clusterLabel*2]), dataPoints_dev[index*2]);
atomicAdd(&(newCentroids_shared[clusterLabel*2 + 1]), dataPoints_dev[index*2 + 1]);
atomicAdd(&(clusterCardinality_shared[clusterLabel]),1);
```


After this update, it is crucial to synchronize again all threads with:

```cpp
__syncthreads();
```


### Part 4: perform reduction
In this final stage, we transfer the intermediate results stored in shared memory back to global memory. 
At this point, each block has accumulated partial sums (for the centroids' coordinates) and counts (for the number of points assigned to each centroid) in its shared arrays. 
To combine these results, we perform a reduction where each thread, with a stride of `blockDim.x`, atomically adds its share of the data to the global arrays. 
This ensures that even if multiple threads update the same global memory location, the operations occur safely and without data races.


{{< includeImage path="/projects/cuda-kmeans/5.png" >}}



The use of `atomicAdd` ensures that these updates are performed safely in a parallel environment.

```cpp
for(int i = localIndex; i < K; i+= blockDim.x) {
	atomicAdd(&(newCentroids_dev[i*2]), newCentroids_shared[i*2]);
	atomicAdd(&(newCentroids_dev[i*2+1]), newCentroids_shared[i*2+1]);
	atomicAdd(&(clusterCardinality_dev[i]), clusterCardinality_shared[i]);
}
```



# Speedup analysis
Now it's time to dive into some numbers. 
The CUDA implementation is dramatically faster than the sequential version. 
To quantify the improvement, independent of the test hardware, we can measure the [speedup](https://en.wikipedia.org/wiki/Speedup). 
The performance gains depend heavily on both the number of centroids $K$ and the total number of data points. 

Let's break down the findings:

$K=5$:
{{< includeImage path="/projects/cuda-kmeans/speedup1.png" >}}

When processing one million data points, we observed a speedup of approximately $4\times$ over the sequential version. 
However, as the number of data points decreases, the speedup also diminishes. This is likely because the overhead of kernel launches and memory transfers becomes more significant when there is less work per kernel call.

$K=100$ and $K=1000$:
{{< includeImage path="/projects/cuda-kmeans/speedup2.png" >}}

The increased computational load per data point (due to more centroid comparisons) allows the GPU to better utilize its parallel processing capabilities. 
Here, the speedup reaches around $35\times$ with one million points. 

## Effects of Threads per Block (TPB)
It is also possibl to experiment varying the number of threads per block:

{{< includeImage path="/projects/cuda-kmeans/speedup_tpb.png" >}}

1. For $K=5$: Using 1024 threads per block turned out to be the slowest configuration. With a small number of centroids, having too many threads may lead to underutilization and increased synchronization overhead.

2. For $K=100$: The performance was roughly the same for different thread block sizes (128, 256, 512, and 1024 TPB). With a moderate workload per data point, the choice of thread block size has a less pronounced effect.

3. For $K=1000$: The best performance was achieved with 1024 threads per block. Here, the heavy computational load per data point benefits from a larger number of threads, which helps hide memory latency and improves overall throughput.



## Profiling with nvprof
To pinpoint any performance bottlenecks, it is possible to use nvprof to profile the CUDA kernels.

For $100$ centroids (and $10^6$ points), the profiling output is:

```
$ sudo nvprof ./build/kmeansCuda datasetUtils/generatedDatasets/1000000_100.csv datasetUtils/generatedDatasets/1000000_100_centroids.csv 
==262564== NVPROF is profiling process 262564, command: ./build/kmeansCuda datasetUtils/generatedDatasets/1000000_100.csv datasetUtils/generatedDatasets/1000000_100_centroids.csv
1.43203
==262564== Profiling application: ./build/kmeansCuda datasetUtils/generatedDatasets/1000000_100.csv datasetUtils/generatedDatasets/1000000_100_centroids.csv
==262564== Profiling result:
            Type  Time(%)      Time     Calls       Avg       Min       Max  Name
 GPU activities:   98.99%  975.56ms       100  9.7556ms  9.6824ms  11.268ms  centroidAssignAndUpdate(float*, float*, float*, int*, int*, int)
                    0.53%  5.2572ms       102  51.540us  1.2800us  5.1211ms  [CUDA memcpy HtoD]
                    0.42%  4.1601ms       201  20.696us  1.6000us  3.8152ms  [CUDA memcpy DtoH]
                    0.05%  507.58us       200  2.5370us  2.4320us  3.1360us  [CUDA memset]
      API calls:   80.00%  991.43ms       303  3.2721ms  6.7720us  11.295ms  cudaMemcpy
                   19.66%  243.61ms         5  48.722ms  6.7250us  242.39ms  cudaMalloc
                    0.18%  2.2049ms       100  22.049us  17.538us  53.918us  cudaLaunchKernel
                    0.10%  1.2148ms       200  6.0740us  3.2930us  17.932us  cudaMemset
                    0.03%  330.19us        97  3.4040us     333ns  141.52us  cuDeviceGetAttribute
                    0.02%  255.02us         4  63.755us  10.132us  205.25us  cudaFree
                    0.01%  130.96us         1  130.96us  130.96us  130.96us  cuDeviceTotalMem
                    0.01%  95.418us         1  95.418us  95.418us  95.418us  cuDeviceGetName
                    0.00%  18.094us         1  18.094us  18.094us  18.094us  cuDeviceGetPCIBusId
                    0.00%  4.4730us         3  1.4910us     331ns  2.8540us  cuDeviceGetCount
                    0.00%  2.2660us         2  1.1330us     678ns  1.5880us  cuDeviceGet
                    0.00%     587ns         1     587ns     587ns     587ns  cuDeviceGetUuid
```

Visually (using [nvvc](https://developer.nvidia.com/nvidia-visual-profiler)), 
{{< includeImage path="/projects/cuda-kmeans/V1.png" class="no-invert" >}}

We can see that:

1. The kernel centroidAssignAndUpdate consumes nearly 99% of the GPU time (about 9.76 ms per call). 
This shows that our main computation is concentrated in this kernel.

2. CUDA memory copy operations (Host-to-Device and Device-to-Host) and memory setting (CUDA memset) take up a very small fraction of the total time. This suggests that data transfers are not the bottleneck.






# Splitting kernel - code V2
One limitation of the code above is that nvprof does not break down the kernel into its internal operations, so it's hard to pinpoint exactly which part of the kernel is the slowest. 
Additionally, I don't have access to NVIDIA's detailed GPU code analysis tools on this hardware (running on an old GeForce 920M 🥵).

To further investigate the performance bottleneck, I decided to split the monolithic kernel into two distinct kernels:

1. **assignmentKernel**: Handles the assignment of points to centroids.
2. **reductionKernel**: Manages the reduction of data in global memory.

This separation allows us to test whether the performance issue is due to atomic operations in global memory or the computational load of the assignment phase.
You can find the code (along with every other source) in the github repository ([link](https://github.com/giggiox/CUDA-kmeans)) under `src/kmeansCudaV2`.


The nvprof output for the split version (with $K=100$ and $10^6$ datapoints) is:

```
$ sudo nvprof ./build/kmeansCudaV2 datasetUtils/generatedDatasets/1000000_100.csv datasetUtils/generatedDatasets/1000000_100_centroids.csv 
==273366== NVPROF is profiling process 273366, command: ./build/kmeansCudaV2 datasetUtils/generatedDatasets/1000000_100.csv datasetUtils/generatedDatasets/1000000_100_centroids.csv
1.05695
==273366== Profiling application: ./build/kmeansCudaV2 datasetUtils/generatedDatasets/1000000_100.csv datasetUtils/generatedDatasets/1000000_100_centroids.csv
==273366== Profiling result:
            Type  Time(%)      Time     Calls       Avg       Min       Max  Name
 GPU activities:   95.98%  999.10ms       100  9.9910ms  9.8939ms  12.846ms  assignmentKernel(float const *, float const *, int*, float*, int*, int)
                    3.15%  32.830ms       100  328.30us  326.46us  336.22us  reductionKernel(float const *, int const *, float*, int*, int)
                    0.50%  5.2460ms       102  51.431us  1.2800us  5.1107ms  [CUDA memcpy HtoD]
                    0.34%  3.5403ms       201  17.613us  1.7920us  3.1501ms  [CUDA memcpy DtoH]
                    0.02%  209.95us       200  1.0490us     992ns  1.3120us  [CUDA memset]
      API calls:   80.24%  1.03968s       200  5.1984ms  324.65us  12.862ms  cudaDeviceSynchronize
                   17.97%  232.80ms         7  33.257ms  6.5090us  231.38ms  cudaMalloc
                    1.11%  14.347ms       303  47.349us  6.1190us  4.3944ms  cudaMemcpy
                    0.28%  3.5906ms       200  17.953us  8.0470us  194.08us  cudaLaunchKernel
                    0.22%  2.7953ms       200  13.976us  8.1290us  48.483us  cudaMemset
                    0.15%  1.9781ms         7  282.59us  6.3570us  896.87us  cudaFree
                    0.03%  334.03us        97  3.4430us     354ns  142.80us  cuDeviceGetAttribute
                    0.01%  124.37us         1  124.37us  124.37us  124.37us  cuDeviceTotalMem
                    0.01%  70.203us         1  70.203us  70.203us  70.203us  cuDeviceGetName
                    0.00%  14.030us         1  14.030us  14.030us  14.030us  cuDeviceGetPCIBusId
                    0.00%  4.1100us         3  1.3700us     376ns  3.2130us  cuDeviceGetCount
                    0.00%  2.3860us         2  1.1930us     408ns  1.9780us  cuDeviceGet
                    0.00%     634ns         1     634ns     634ns     634ns  cuDeviceGetUuid
```

Visually 

{{< includeImage path="/projects/cuda-kmeans/V2.png" class="no-invert" >}}


We can observe that
1. **assignmentKernel**: This kernel still takes up about 96% of the GPU execution time (averaging roughly 10 ms per call). This indicates that the bulk of the computational load remains in the assignment phase. So the atomics in the reduction phase are **not** the bottleneck.

2. **reductionKernel**: The reduction step accounts for only about 3% of the GPU time, suggesting that atomic operations in global memory (often a concern with reductions) are not the main performance issue.

In summary, while the CUDA implementation scales very well and achieves significant speedup over the sequential version, the profiling data indicates that our primary focus for further optimization should be on the assignment phase of the algorithm rather than the atomic operations used in global memory.






# Just for fun - openmp parallelization
The sequential code i wrote is very easy to parallelize using openmp - so why not do it and see how it compares with CUDA?

The logic behind this code is very similar to the CUDA version, with the difference that having no concept of blocks, the local variables have a thread scope.

You can find a intuitive guide about openmp [here](https://ppc.cs.aalto.fi/ch2/openmp/).


```cpp
void centroidAssignAndUpdate(
    float* dataPoints, float* centroids, float* newCentroids, int* clusterCardinality, 
    int* clusterLabel, int N) {

#pragma omp parallel
{
    float newCentroidsLocal[K * 2] = {0.0f};
    int clusterCardinalityLocal[K] = {0};

#pragma omp for schedule(static)
    for (int i = 0; i < N; ++i) {
        float minDistance = INFINITY;
        int cluster = 0;
        for (int j = 0; j < K; ++j) {
            float distance = distanceMetric(dataPoints[i * 2], dataPoints[i * 2 + 1], centroids[j * 2], centroids[j * 2 + 1]);
            if (distance < minDistance) {
                minDistance = distance;
                cluster = j;
            }
        }
        clusterLabel[i] = cluster;
        newCentroidsLocal[cluster * 2] += dataPoints[i * 2];
        newCentroidsLocal[cluster * 2 + 1] += dataPoints[i * 2 + 1];
        clusterCardinalityLocal[cluster]++;
    }

    for (int i = 0; i < K; ++i) {
#pragma omp atomic
        clusterCardinality[i] += clusterCardinalityLocal[i];
#pragma omp atomic
        newCentroids[2*i] += newCentroidsLocal[2*i];
#pragma omp atomic
        newCentroids[2*i+1] += newCentroidsLocal[2*i+1];
    }

}
```

Again, we can play with some parameters but with this version i was able to produce a **speedup of maximum $\approx 2.5$**.


Note that my CPU is not really *capable* (i3-4005U **4 cores** 1.600GHz).


# Conclusion
In this project, we've explored the inner workings of a CUDA implementation of the K-Means clustering algorithm, from understanding the algorithm itself to diving into the nuances of GPU kernel design and optimization. 
We saw how careful use of shared memory and atomic operations can significantly accelerate the computationally heavy assignment step, leading to impressive speedups over sequential and even CPU-parallelized implementations.

One important aspect we haven't delved into deeply is dimensionality. 
While the implementation i presented works for points in 2 dimension, it can be easily extended for more dimension while keeping a SoA architecture.

When working with data points in higher dimensional spaces, the shared memory requirements increase. 
In our kernel, the memory needed for storing centroids in shared memory scales with both the number of centroids (K) and the dimensionality (dim) of the data. 
The general formula for shared memory allocation becomes:

$$(\text{dim} *K\times 4) + (K\times 4) \leq 49152$$
$$ K \leq \frac{4096}{1 + \text{dim}}$$


Increasing the dimensionality of your data will reduce the maximum number of centroids you can store in shared memory. 
This insight is crucial for scaling the algorithm to more complex, higher dimensional datasets and might prompt alternative strategies, like using dynamic shared memory or even global memory to maintain performance.


All in all, I truly enjoyed diving into CUDA programming. 
Although the indexing was initially challenging, witnessing the dramatic speedup made the effort incredibly rewarding 🚀. I look forward to working more with CUDA in the future!

{{< rawhtml >}}

 <script>
    // Simulation parameters
    const numPoints = 300;
    const numCentroids = 3;
    const canvasSize = 500;

    // Utility: Delay function (used for sequential animation)
    function delay(ms) {
      return new Promise(resolve => setTimeout(resolve, ms));
    }

    // Utility: Gaussian random generator (Box-Muller transform)
    function gaussianRandom() {
      let u = 0, v = 0;
      while (u === 0) u = Math.random();
      while (v === 0) v = Math.random();
      return Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
    }

    // Utility: Return a color string based on index
    function getColor(index) {
      const colors = ["red", "green", "blue", "orange", "purple"];
      return colors[index % colors.length];
    }

    // Creates a simulation instance with its own points, centroids, and assignments.
    function createSimulation() {
      const sim = {
        points: [],
        centroids: [],
        assignments: []
      };

      // Initialize points as Gaussian blobs around true centers.
      const trueCenters = [
        { x: canvasSize * 0.3, y: canvasSize * 0.3 },
        { x: canvasSize * 0.7, y: canvasSize * 0.3 },
        { x: canvasSize * 0.5, y: canvasSize * 0.7 }
      ];
      for (let i = 0; i < numPoints; i++) {
        const center = trueCenters[i % trueCenters.length];
        const stdDev = 30;
        const x = center.x + gaussianRandom() * stdDev;
        const y = center.y + gaussianRandom() * stdDev;
        sim.points.push({ x, y });
        sim.assignments.push(-1);
      }

      // Initialize centroids at random positions.
      for (let i = 0; i < numCentroids; i++) {
        sim.centroids.push({
          x: Math.random() * canvasSize,
          y: Math.random() * canvasSize,
          color: getColor(i)
        });
      }
      return sim;
    }

    // Draw the current state of a simulation on the given canvas with a label.
    function drawSim(sim, canvas, label) {
      const ctx = canvas.getContext("2d");
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      // Draw points
      for (let i = 0; i < numPoints; i++) {
        ctx.beginPath();
        ctx.arc(sim.points[i].x, sim.points[i].y, 3, 0, Math.PI * 2);
        const cluster = sim.assignments[i];
        ctx.fillStyle = (cluster !== -1) ? sim.centroids[cluster].color : "gray";
        ctx.fill();
      }
      // Draw centroids
      for (let i = 0; i < numCentroids; i++) {
        ctx.beginPath();
        ctx.arc(sim.centroids[i].x, sim.centroids[i].y, 8, 0, Math.PI * 2);
        ctx.fillStyle = sim.centroids[i].color;
        ctx.fill();
        ctx.strokeStyle = "black";
        ctx.stroke();
      }
      // Draw label text
      ctx.font = "20px Arial";
	  let color = "black";
	  if (isDarkMode){
		color = "white";
	  }
      ctx.fillStyle = color;
	  var lines = label.split('\n');
	  for (var j = 0; j < lines.length; j++){
	    ctx.fillText(lines[j], 10, 30 + (j * 25));
	  }
      
    }

    // Assign one point to its closest centroid for a given simulation.
    function assignPoint(sim, pointIndex) {
      let minDist = Infinity;
      let closest = -1;
      for (let j = 0; j < numCentroids; j++) {
        const dx = sim.points[pointIndex].x - sim.centroids[j].x;
        const dy = sim.points[pointIndex].y - sim.centroids[j].y;
        const dist = dx * dx + dy * dy;
        if (dist < minDist) {
          minDist = dist;
          closest = j;
        }
      }
      sim.assignments[pointIndex] = closest;
    }

	
	async function sequentialUpdateAnimated(sim, canvas) {
      // Reset assignments.
      for (let i = 0; i < numPoints; i++) {
        sim.assignments[i] = -1;
      }
      drawSim(sim, canvas, "");

      // Assign points one by one with a delay.
	  const sums = Array(numCentroids).fill(0).map(() => ({ x: 0, y: 0 }));
      const counts = Array(numCentroids).fill(0);
      for (let i = 0; i < numPoints; i++) {
        assignPoint(sim, i);
        if (i % 10 === 0 || i === numPoints - 1) {
          drawSim(sim, canvas, `Assigned ${i + 1}/${numPoints} points`);
        }
        await delay(30);
		
		const cluster = sim.assignments[i];
		if (cluster !== -1) {
          sums[cluster].x += sim.points[i].x;
          sums[cluster].y += sim.points[i].y;
          counts[cluster]++;
        }
      }
	  for (let j = 0; j < numCentroids; j++) {
        if (counts[j] > 0) {
          sim.centroids[j].x = sums[j].x / counts[j];
          sim.centroids[j].y = sums[j].y / counts[j];
        } 
		drawSim(sim, canvas, `Assigned ${numPoints}/${numPoints} points ✅\nUpdated ${j+1}/${numCentroids} centroids`);
		await delay(1000);
	  }
	  drawSim(sim, canvas, `Assigned ${numPoints}/${numPoints} points ✅\nUpdated ${numCentroids}/${numCentroids} centroids ✅\nIteration complete`);
	  document.getElementById("updateSeqBtn1").disabled = false;
	  document.getElementById("initBtn1").disabled = false;

    }

    

    const sim1 = createSimulation();
    const canvas1 = document.getElementById("canvas1");
    drawSim(sim1, canvas1, "Sequential");


    document.getElementById("initBtn1").addEventListener("click", function () {	
      // Reinitialize centroids (and reset assignments) for sim1.
      sim1.centroids = [];
      for (let i = 0; i < numCentroids; i++) {
        sim1.centroids.push({
          x: Math.random() * canvasSize,
          y: Math.random() * canvasSize,
          color: getColor(i)
        });
      }
      // Reset assignments.
      sim1.assignments = new Array(numPoints).fill(-1);
      drawSim(sim1, canvas1, "Sequential");
    });

    document.getElementById("updateSeqBtn1").addEventListener("click", function () {
	  document.getElementById("updateSeqBtn1").disabled = true;
	  document.getElementById("initBtn1").disabled = true;
      sequentialUpdateAnimated(sim1, canvas1);
    });
	
	
	
	document.getElementById("theme-toggle").addEventListener("click", () => {
		if (document.body.className.includes("dark")) {
			isDarkMode = false;
		} else {
			isDarkMode = true;
		}
		document.body.classList.toggle('d-mode', isDarkMode);
		document.body.classList.toggle('l-mode', !isDarkMode);
		drawSim(sim1, canvas1, "Sequential");
	})


  </script>
{{< /rawhtml >}}