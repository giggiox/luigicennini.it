---
title: "leetcode solutions"
date: 2024-09-01T19:53:33+05:30
draft: false
author: "Luigi"
tags:
  - Rich content
  - Sample
  - example
image: /projects/leetcode-solutions/back.png
description: ""
toc: true
mathjax: true
---


{{< rawhtml >}}
<style>
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
  margin-left: 20px;
}

details details {
  margin-left: calc(20px * 2);
}

details details details {
  margin-left: calc(20px * 3);
}









</style>


<script>
    MathJax = {
        tex: {
            inlineMath: [["$", "$"]]
        }
    };
</script>
    
{{< /rawhtml >}}


This project is primarily for me. It's a way to organize my leetcode solutions in a way that’s easily searchable and comparable. 
Also because I've noticed that many resources, especially when it comes to dynamic programming problems, often skip over the naive or memoized solutions, jumping straight to the optimized versions. I believe understanding these intermediate steps is crucial, so I aim to include them wherever relevant.

My goals with this blog are:

- To create a more intuitive categorization of problems, making it easier to find and revisit specific types of challenges.
- To provide visualizations that help explain the solutions, along with code that directly reflects these visualizations.

Not all solutions have visual aids just yet, but they will be added over time as I continue to build and refine this space.

# General problems

{{< include path="/projects/leetcode-solutions/general-problems/53/solution.md" >}}
{{< include path="/projects/leetcode-solutions/general-problems/287/solution.md" >}}
{{< include path="/projects/leetcode-solutions/general-problems/136/solution.md" >}}
{{< include path="/projects/leetcode-solutions/general-problems/1/solution.md" >}}
{{< include path="/projects/leetcode-solutions/general-problems/167/solution.md" >}}
{{< include path="/projects/leetcode-solutions/general-problems/15/solution.md" >}}

# Prefix array 

{{< include path="/projects/leetcode-solutions/prefix-array/238/solution.md" >}}


# Binary Search

{{< include path="/projects/leetcode-solutions/binary-search/704/solution.md" >}}
{{< include path="/projects/leetcode-solutions/binary-search/74/solution.md" >}}
{{< include path="/projects/leetcode-solutions/binary-search/153/solution.md" >}}
{{< include path="/projects/leetcode-solutions/binary-search/33/solution.md" >}}


# Linked list

{{< include path="/projects/leetcode-solutions/linked-list/206/solution.md" >}}
{{< include path="/projects/leetcode-solutions/linked-list/21/solution.md" >}}
{{< include path="/projects/leetcode-solutions/linked-list/143/solution.md" >}}
{{< include path="/projects/leetcode-solutions/linked-list/19/solution.md" >}}
{{< include path="/projects/leetcode-solutions/linked-list/146/solution.md" >}}



# Trees
{{< include path="/projects/leetcode-solutions/trees/visits/solution.md" >}}
{{< include path="/projects/leetcode-solutions/trees/226/solution.md" >}}
{{< include path="/projects/leetcode-solutions/trees/104/solution.md" >}}
{{< include path="/projects/leetcode-solutions/trees/110/solution.md" >}}
{{< include path="/projects/leetcode-solutions/trees/100/solution.md" >}}
{{< include path="/projects/leetcode-solutions/trees/572/solution.md" >}}
{{< include path="/projects/leetcode-solutions/trees/102/solution.md" >}}
{{< include path="/projects/leetcode-solutions/trees/199/solution.md" >}}
{{< include path="/projects/leetcode-solutions/trees/543/solution.md" >}}
{{< include path="/projects/leetcode-solutions/trees/236/solution.md" >}}
{{< include path="/projects/leetcode-solutions/trees/617/solution.md" >}}
{{< include path="/projects/leetcode-solutions/trees/124/solution.md" >}}

# Backtracking	
{{< include path="/projects/leetcode-solutions/backtrack/78/solution.md" >}}
{{< include path="/projects/leetcode-solutions/backtrack/46/solution.md" >}}
{{< include path="/projects/leetcode-solutions/backtrack/39/solution.md" >}}

# Dynamic Programming
{{< include path="/projects/leetcode-solutions/dp/70/solution.md" >}}
{{< include path="/projects/leetcode-solutions/dp/322/solution.md" >}}
{{< include path="/projects/leetcode-solutions/dp/91/solution.md" >}}

# Graphs
{{< include path="/projects/leetcode-solutions/graphs/visits/solution.md" >}}
{{< include path="/projects/leetcode-solutions/graphs/topological-sort/solution.md" >}}
{{< include path="/projects/leetcode-solutions/graphs/detect-cycles/solution.md" >}}
{{< include path="/projects/leetcode-solutions/graphs/200/solution.md" >}}
{{< include path="/projects/leetcode-solutions/graphs/130/solution.md" >}}
{{< include path="/projects/leetcode-solutions/graphs/207/solution.md" >}}
{{< include path="/projects/leetcode-solutions/graphs/210/solution.md" >}}

# Greedy
{{< include path="/projects/leetcode-solutions/greedy/interval-schedule/solution.md" >}}
{{< include path="/projects/leetcode-solutions/greedy/435/solution.md" >}}