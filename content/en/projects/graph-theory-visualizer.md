---
title: "Graph Theory Visualizer"
date: 2022-01-01T19:53:33+05:30
draft: false
author: "Luigi"
tags:
  - projects
  
hideCover: false
image: /projects/graphtheoryvisualizer/graph.png
summary: "Online graph algorithm interactive visualization."
toc: true
mathjax: true
---

The project was done to visualize the operations that can be done on a graph, such as BFS, DFS, Kruskal, and Dijkstra.

The goal is to have a real time update of the various operations, so that if the graph changes while an 'operation is being performed on it, the result of the operation also changes.

The project is active on GitHub pages and a demo can be accessed from this link: 
{{< rawhtml >}}
<center>
{{</ rawhtml >}}
👉[https://giggiox.github.io/graphTheory-Visualizer/](https://giggiox.github.io/graphTheory-Visualizer/)👈
{{< rawhtml >}}
</center>
{{</ rawhtml >}}
The GUI looks like this:
![](/projects/graphtheoryvisualizer/interface.gif)

and allows:
- create new vertex (on-screen `vertex` button)
- create an arc between two vertices (on-screen `edge` button) by clicking first on the first vertex and then on the second
- remove an arc between two vertices by clicking on it
- set the graph as weighted and/or directed (switches present on the screen)
- see the adjacency list as a dropdown. Notice how if the graph changes for example if you remove an arc, the list changes in real time
- visualize the possible operations on a graph. It is necessary to choose the operation with the dropdown present in the navbar and then start the visualization. Note how even in this case, for example if we choose to display the Dijkstra algorithm and in the process we change the graph by moving the vertices, then the output of the algorithm also changes in real time. The output of an algorithm is displayed on the graph by highlighting vertices and arcs in blue.


## examples
depth-first search (DFS):
![](/projects/graphtheoryvisualizer/dfs.gif)


dijkstra shortest path between 2 vertices:
![](/projects/graphtheoryvisualizer/dijkstra.gif)

kruskal minimum spanning tree:
![](/projects/graphtheoryvisualizer/kruskal.gif)


Project done using [p5js](https://p5js.org/) and [TypeScript](https://www.typescriptlang.org/).

