---
title: "Design Patterns - handbook"
date: 2024-11-05T19:53:33+05:30
draft: false
author: "Luigi"
tags:
  - Rich content
  - Sample
  - example
image: /projects/design-patterns/aaaa.png
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

h1 a {
            text-decoration: underline;
            cursor: pointer;
            color: blue;
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



I made this project as an easy way to access and revise design patterns. 

There are plenty of resources online about design patterns, so why did i made mine?

This is because the resources i found:

- Do not have the right balance between too verbose and straight to the point explanation.
- Are not *easily* searchable: why so many pages-subpages where i can't just ctrl+f (or cmd+f), and also always so many clicks away to knowing the solution.

So here you go, take a look into this fabulous handbook of design patterns!




{{< rawhtml >}}
<div id="design-patterns">




<div class="container text-center">
    <div class="row">
        <div class="col-12 text-center">
            <button id="toggleAll" class="btn btn-primary">
                <span id="buttonText">expand all</span>
            </button>
        </div>
    </div>
</div>
{{< /rawhtml >}}

## Creational
{{< include path="/projects/design-patterns/factorymethod/solution.md" >}}
{{< include path="/projects/design-patterns/staticfactorymethod/solution.md" >}}
{{< include path="/projects/design-patterns/abstractfactory/solution.md" >}}
{{< include path="/projects/design-patterns/builder/solution.md" >}}
{{< include path="/projects/design-patterns/fluentinterface/solution.md" >}}
{{< include path="/projects/design-patterns/singleton/solution.md" >}}

# Structural
{{< include path="/projects/design-patterns/decorator/solution.md" >}}
{{< include path="/projects/design-patterns/facade/solution.md" >}}
{{< include path="/projects/design-patterns/adapter/solution.md" >}}

# Behavioral
{{< include path="/projects/design-patterns/observer/solution.md" >}}
{{< include path="/projects/design-patterns/pubsub/solution.md" >}}
{{< include path="/projects/design-patterns/strategy/solution.md" >}}
{{< include path="/projects/design-patterns/state/solution.md" >}}
{{< include path="/projects/design-patterns/visitor/solution.md" >}}
{{< include path="/projects/design-patterns/iterator/solution.md" >}}
{{< include path="/projects/design-patterns/chainofresponsability/solution.md" >}}



{{< rawhtml >}}
</div>
{{< /rawhtml >}}



{{< rawhtml >}}
<script>


const toggleLink = document.getElementById("toggleAll");
const detailsElements = document.querySelectorAll("#design-patterns details");
let allExpanded = false; 

toggleLink.addEventListener("click", () => {
    allExpanded = !allExpanded;
    detailsElements.forEach(details => details.open = allExpanded);            
    toggleLink.textContent = allExpanded ? "Close All" : "Expand All";
});

</script>
    
	
{{< /rawhtml >}}