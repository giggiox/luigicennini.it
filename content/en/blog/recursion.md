---
title: "How i think about recursion"
date: 2025-02-16T19:53:33+05:30
draft: true
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


{{< includeImage path="/blog/recursion/1.png" >}}


Luigi