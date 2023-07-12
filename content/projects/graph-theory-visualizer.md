---
title: "graph theory visualizer"
date: 2022-01-01T19:53:33+05:30
draft: false
author: "Luigi"
tags:
  - Rich content
  - Sample
  - example
image: /projects/graphtheoryvisualizer/graph.png
description: ""
toc: true
mathjax: true
---

# graphTheory-Visualizer

Il progetto è stato fatto per visualizzare le operazioni che possono essere fatte su un grafo, come BFS, DFS, Kruskal e Dijkstra.

L'obiettivo è quello di avere un update real time delle varie operazioni, in modo che se il grafo cambia mentre vi si sta svolgendo un' operazione, anche il risultato dell'operazione cambia.


Il progetto è attivo sulle GitHub pages e può essere accessibile una demo da questo link  (fruibile più semplicemente da desktop): https://giggiox.github.io/graphTheory-Visualizer/  <br/><br/>

L'interfaccia grafica si presenta in questo modo:
![](/projects/graphtheoryvisualizer/interface.gif)

e permette:
- creare nuovo vertice (bottone a schermo `vertex`)
- creare un arco tra due vertici (bottone a schermo `edge`) cliccando prima sul primo vertice e poi sul secondo
- rimuovere un arco tra due vertici cliccandoci sopra
- impostare il grafo come pesato e/o diretto (switch presenti a schermo)
- vedere la lista di adiacenza come dropdown. Notare come se il grafo cambia per esempio se si elimina un arco, la lista cambia in tempo reale
- visualizzare le operazioni possibili su un grafo. E' necessario scegliere l'operazione con il dropdown presente nella navbar e poi iniziare la visualizzazione. Notare come anche in questo caso, per esempio se si sceglie di visualizzare l'algoritmo Dijkstra e nel mentre cambiamo il grafico muovendo i vertici, allora anche l'output dell'algoritmo cambia in tempo reale. L'output di un algoritmo viene visualizzato sul grafo evidenziando vertici e archi di blu.


## esempi
depth-first search (DFS):
![](/projects/graphtheoryvisualizer/dfs.gif)


dijkstra shortest path between 2 vertices:
![](/projects/graphtheoryvisualizer/dijkstra.gif)

kruskal minimum spanning tree:
![](/projects/graphtheoryvisualizer/kruskal.gif)


Progetto fatto usando [p5js](https://p5js.org/) e [TypeScript](https://www.typescriptlang.org/).

