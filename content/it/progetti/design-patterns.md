---
title: "Design Patterns - handbook"
date: 2024-11-05T19:53:33+05:30
draft: false
author: "Luigi"
tags:
  - Rich content
  - Sample
  - example
image: /projects/design-patterns/copertina.png
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


Questo progetto vuole essere un handbook per i design pattern.

Per maggiori dettagli, visita la pagina in inglese [design-patterns handbook](https://www.luigicennini.it/en/projects/design-patterns/).