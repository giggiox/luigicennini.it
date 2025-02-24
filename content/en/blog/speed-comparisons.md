---
title: "Understanding Memory Hierarchy & cache locality"
date: 2025-02-20T19:53:33+05:30
draft: false
author: "Luigi"
tags:
  - blog
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

 body.d-mode canvas {
	background: #212529;
	width: 100%;
	height: auto;
 }
	
 body.l-mode canvas {
	background: #F2F2F2;
	width: 100%;
	height: auto;
 }
	
    .controls {
      margin-top: 20px;
    }
    /* Stile per la label dello slider */
    #scalingInfo {
      font-size: 16px;
      font-weight: bold;
      margin-bottom: 10px;
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
.no-invert {
	filter: none !important;
}
	
  </style>
  
<script>
var isDarkMode = document.body.className.includes("dark");
document.body.classList.toggle('d-mode', isDarkMode);
document.body.classList.toggle('l-mode', !isDarkMode);

</script>

    
{{< /rawhtml >}}

Everybody knows what a CPU looks like on the inside


*...no?*

Well, for those of you that don't know, here is a picture of it's insides:

{{< includeImage path="/blog/cache/4.png" class="no-invert">}}

From this picture you can notice something interesting about caches and caches placements.
In fact you can see that L1 caches are the closest to the cores and L3 caches are the furthest.
This is why L1 are also the fastest and L3 the slowest among the three levels shown in the picture.

I recently found a speed comparison visualiazation between caches by [Benj Dicken](https://benjdd.com/) in [this X post](https://x.com/BenjDicken/status/1847310000735330344), and since i couldn't find anywhere to play with his visualization, I recreated it here (which is mostly why I am writing this post 😅 ):


{{< rawhtml >}} 
<center>
<canvas id="simulationCanvas" width="800" height="400"></canvas>
<div class="controls">
    <p id="scalingInfo">Simulazione in slow motion: 1.0e+9x slower</p>
    <input type="range" id="myRange" min="6" max="9" step="0.1" value="9">
  </div>
</center>
{{< /rawhtml >}}

I think this visualization is beautiful because it lets you grasp *why* paying awerness to cache while programming let's you write...well, faster algorithms!

Take a look at the example below to see why knowing your hardware is relevant.

# Row-major vs Column-major
Consider a 4x4 matrix stored in memory. While we visualize it as a grid, the physical storage is linear. 
In C/C++, arrays use row-major order, meaning rows are stored sequentially:

{{< includeImage path="/blog/cache/1.png">}}

In the image above you can see (top) the logical view of the matrix and (bottom) the physical view of it.

# Cache behavior: Row-Major Access
Suppose we are in a Row-major environment and we access the matrix row-first, i.e like this:

{{< includeImage path="/blog/cache/2.png">}}

Also suppose that we have only one level of cache which has a size of 32 bytes (holds 4 integers) and the cache lines are of size 16 bytes (holds 2 integers), when iterating through the matrix this is how cache behaves:

{{< rawhtml >}}
<center>
{{< /rawhtml >}}
| step | index   | cache (before)       | cache (after)        | cache miss |
| ---- | ------- | -------------------- | -------------------- | ---------- |
| 1    | A[0][0] | -                    | **[1,2]**            | miss       |
| 2    | A[0][1] | **[1,2]**            | **[1,2]**            | hit        |
| 3    | A[0][2] | **[1,2]**            | **[1,2], [3,4]**     | miss       |
| 4    | A[0][3] | **[1,2], [3,4]**     | **[1,2], [3,4]**     | hit        |
| 5    | A[1][0] | **[1,2], [3,4]**     | **[3,4], [5,6]**     | miss       |
| ...   | ... | ... | ... | ...       |
| 16   | A[3][3] | **[13,14], [15,16]** | **[13,14], [15,16]** | hit        |

{{< rawhtml >}}
</center>
{{< /rawhtml >}}


You can see that everytime there is a *cache miss* a cache line (2 integers) is transfered to the cache.

**Result**: iterating row-first gives us **50% cache miss rate**.



# Cache behavior: Column-Major Access
Suppose you are in the same environment as above, but this time you iterate through the matrix **column-first**, i.e like this:
{{< includeImage path="/blog/cache/3.png">}}

This is the access pattern you get:

{{< rawhtml >}}
<center>
{{< /rawhtml >}}

|step|index|cache (before)|cache (after)|cache miss|
|---|---|---|---|---|
|1|A[0][0]|-|**[1,2]**|miss|
|2|A[1][0]|**[1,2]**|**[1,2], [5,6]**|miss|
|3|A[2][0]|**[1,2], [5,6]**|**[5,6], [9,10]**|miss|
|4|A[3][0]|**[5,6], [9,10]**|**[9,10], [13,14]**|miss|
|5|A[0][1]|**[9,10], [13,14]**|**[1,2], [3,4]**|miss|
|...|...|...|...|...|
|16|A[3][3]|**[5,6], [9,10]**|**[9,10], [13,14]**|miss|

{{< rawhtml >}}
</center>
{{< /rawhtml >}}

Notice how this time you are wasting every cache line is brought into cache.

**Result**: iterating column-first gives us **100% cache miss rate**.


# Benchmarking Row vs. Column Access
This C program demonstrates the performance difference:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#ifndef N
#define N 4096
#endif

int mat[N][N] = {0};

#ifdef COLUMN_FIRST
void iterate() {
    int i, j;
    for (j = 0; j < N; j++) {
        for (i = 0; i < N; i++) {
            mat[i][j] += 1; // Column-major access
        }
    }
}
#else
void iterate() {
    int i, j;
    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            mat[i][j] += 1; // Row-major access
        }
    }
}
#endif

int main() {
    clock_t start, end;
    double time;
    start = clock();
    iterate();
    end = clock();
    time = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("Time: %fs\n", time);
    return 0;
}
```

**Results**: 
1. For column first compile the code with the `COLUMN_FIRST` flag
```
$ gcc -DCOLUMN_FIRST script.c -o columnfirst
$ ./columnfirst
Time: 0.524808s  
```
2. For the row first compile the code without any flag
```
$ gcc script.c -o rowfirst
$ ./rowfirst
Time: 0.178195s
```
Column-first access is **more than double slower**.
We can prove that this is due to cache misses using profiling tools like `perf stat`.

1. Row-First Performance

```bash
$ perf stat -e cache-references,cache-misses,cycles,instructions,branches,faults,migrations ./rowfirst
Time: 0.178195s

 Performance counter stats for './rowfirst':

           285.676      cache-references                                            
           137.135      cache-misses              #   48,004 % of all cache refs    
       285.008.599      cycles                                                      
       468.998.728      instructions              #    1,65  insn per cycle         
        35.080.708      branches                                                    
            32.825      faults                                                      
                 1      migrations                                                  

       0,187476169 seconds time elapsed

       0,117382000 seconds user
       0,068810000 seconds sys
```

2. Column-First Performance
```bash
$ perf stat -e cache-references,cache-misses,cycles,instructions,branches,faults,migrations ./columnfirst
Time: 0.524808s

 Performance counter stats for './columnfirst':

        17.404.939      cache-references                                            
        15.918.948      cache-misses              #   91,462 % of all cache refs    
       838.541.074      cycles                                                      
       469.594.444      instructions              #    0,56  insn per cycle         
        35.178.138      branches                                                    
            32.826      faults                                                      
                 2      migrations                                                  

       0,536358950 seconds time elapsed

       0,484255000 seconds user
       0,047631000 seconds sys
```


You can see that in row-first access we get **48,004\%** cache misses, while in column first **91,462\%**. Almost double, like seen in the section above.

*Ta-Da!*

Luigi






{{< rawhtml >}} 
<script>
    const canvas = document.getElementById('simulationCanvas');
    const ctx = canvas.getContext('2d');
    const myRange = document.getElementById('myRange');
    const scalingInfo = document.getElementById('scalingInfo');

    // Calcola il fattore di rallentamento: 10^(valore dello slider)
    let slowdownFactor = Math.pow(10, myRange.value);
    // Per gestire la continuità della fase, teniamo traccia del vecchio valore
    let lastSlowdownFactor = slowdownFactor;
    scalingInfo.textContent = slowdownFactor + "x slower";

    // Definizione della CPU: un rettangolo grande a sinistra
    const cpu = {
      x: 50,
      y: 10,
      width: 150,
      height: 380,
      color: "#a2d5f2",
      label: "CPU"
    };

    /* 
      Definizione degli elementi di memoria (cache e RAM).
      Ogni elemento ha:
        - posizione e dimensioni (rettangolo)
        - una latenza base (in nanosecondi)
        - un'etichetta per la latenza (visualizzata all'interno)
        - un offset per mantenere la continuità della fase
    */
    const memoryElements = [
      { label: "L1 cache",  x: 600, y: 10,  width: 120, height: 80,  baseLatency: 1,  color: "#ffcc5c", latency: "1 ns",  offset: 0 },
      { label: "L2 cache",  x: 600, y: 110, width: 120, height: 80,  baseLatency: 4,  color: "#f6d186", latency: "4 ns",  offset: 0 },
      { label: "L3 cache",  x: 600, y: 210, width: 120, height: 80,  baseLatency: 40, color: "#ffde7d", latency: "40 ns", offset: 0 },
      { label: "RAM", x: 600, y: 310, width: 120, height: 80,  baseLatency: 80, color: "#ff6f69", latency: "80 ns", offset: 0 }
    ];

    let startTime = null;
    let animationId;

    // Funzione per disegnare un rettangolo con etichetta e latenza (se presente)
    function drawRectangle(rect) {
      ctx.fillStyle = rect.color;
      ctx.fillRect(rect.x, rect.y, rect.width, rect.height);
      ctx.strokeStyle = "#000";
      ctx.strokeRect(rect.x, rect.y, rect.width, rect.height);
      ctx.fillStyle = "#000";
      ctx.font = "16px Arial";
      ctx.textAlign = "center";
      ctx.fillText(rect.label, rect.x + rect.width / 2, rect.y + rect.height / 2);
      if (rect.latency) {
        ctx.font = "14px Arial";
        ctx.fillText(rect.latency, rect.x + rect.width / 2, rect.y + rect.height / 2 + 20);
      }
    }

    // Funzione per disegnare un pallino
    function drawBall(x, y, radius, color) {
      ctx.beginPath();
      ctx.arc(x, y, radius, 0, Math.PI * 2);
      ctx.fillStyle = color;
      ctx.fill();
      ctx.strokeStyle = "#000";
      ctx.stroke();
    }

    // Funzione di animazione: ogni pallino oscilla orizzontalmente
    function animate(timestamp) {
      if (!startTime) startTime = timestamp;
      const elapsed = timestamp - startTime;

      // Pulizia del canvas
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      // Disegna la CPU (statico)
      drawRectangle(cpu);

      // Per ogni elemento di memoria (cache e RAM)
      memoryElements.forEach(element => {
        drawRectangle(element);

        const margin = 10;      // margine interno al rettangolo
        const ballRadius = 8;   // raggio del pallino

        // Calcola il periodo (in ms) in base alla latenza (ns) e al fattore di rallentamento
        const period = (element.baseLatency * slowdownFactor) / 1e6;
        // Usa l'offset per mantenere continuità nella fase
        const effectiveTime = elapsed + element.offset;
        // Calcola la fase (0-1) dell'oscillazione
        const phase = (effectiveTime % period) / period;
        const sinValue = (Math.sin(phase * 2 * Math.PI) + 1) / 2;

        // Il pallino oscilla da destra della CPU (cpu.x + cpu.width) fino al margine sinistro dell'elemento
        const startX = cpu.x + cpu.width + margin;
        const endX = element.x - margin;
        const ballX = startX + sinValue * (endX - startX);
        const ballY = element.y + element.height / 2;

        drawBall(ballX, ballY, ballRadius, "#6a994e");
      });

      animationId = requestAnimationFrame(animate);
    }

    // Gestione dello slider senza resettare l'animazione
    myRange.addEventListener('input', () => {
      const newFactor = Math.pow(10, myRange.value);
      const currentTime = performance.now();
      if (startTime !== null) {
        const elapsed = currentTime - startTime;
        // Per ogni elemento, aggiorna l'offset per mantenere la continuità della fase
        memoryElements.forEach(element => {
          const oldPeriod = (element.baseLatency * lastSlowdownFactor) / 1e6;
          const newPeriod = (element.baseLatency * newFactor) / 1e6;
          // Calcola la frazione di fase attuale con il vecchio periodo
          const currentPhase = ((elapsed + element.offset) % oldPeriod) / oldPeriod;
          // Imposta il nuovo offset in modo che:
          // (elapsed + nuovoOffset) mod newPeriod = currentPhase * newPeriod
          element.offset = (currentPhase * newPeriod) - elapsed;
        });
      }
      slowdownFactor = newFactor;
      lastSlowdownFactor = slowdownFactor;
      scalingInfo.textContent = slowdownFactor + "x slower";
    });

    // Avvia l'animazione
    startTime = null;
    cancelAnimationFrame(animationId);
    animationId = requestAnimationFrame(animate);
  </script>
{{< /rawhtml >}}







{{< rawhtml >}} 
<script>
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




