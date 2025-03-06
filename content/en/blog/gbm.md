---
title: "Interactive Gradient Boosting Machine"
date: 2025-02-27T19:53:33+05:30
draft: true
author: "Luigi"
tags:
  - blog
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

.math-container {
    overflow-x: auto;
    display: block;
    max-width: 100%;
    text-align: center;
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

Curious about how Gradient Boosting Machines (GBMs) really work? I've built an interactive visualization to demystify the process!

## GBM basics
GBMs learn iteratively, focusing on the errors of previous trees. 
This incremental approach builds a powerful predictive model. 
Here's a quick visual reminder of the algorithm (from [Friedman paper in 2001](https://jerryfriedman.su.domains/ftp/trebst.pdf)):

Given a dataset ${(x_i,y_i)}_{i=1}^{n}$
{{< includeImage path="/blog/gbm/algo.PNG" >}}

There are many resources online explaining the algorithm, like this one so I won't rehash it. 
Instead, let's get hands-on and see GBM in action.

## Visualizing Shallow Trees (Depth 1)
First, let's visualize GBM building 50 trees, each with a depth of 1.

{{< rawhtml >}}
<center>
<div class="container">
        <div class="info">
            <h3 id="stepInfo">Initial Prediction (Base Value)</h3>
            <div id="details"></div>
        </div>
        <canvas id="plotCanvas" width="1000" height="700"></canvas>
        <div class="controls">
            <button id="prevBtn" disabled>Previous Step</button>
            <button id="nextBtn">Next Step</button>
            <button id="resetBtn">Reset</button>
        </div>
		<input type="range" min="0" max="50" value="0" class="slider" id="myRange">

    </div>
</center>  
{{< /rawhtml >}}

**What you are seeing**: 
- $\gamma_i$: This represents the individual tree built on the residuals (errors) from the previous prediction.
- $F_i$: This is the updated prediction, where each new tree's contribution is added to the previous prediction, scaled by the learning rate (0.1 in this case).

## Visualizing Deeper Trees (Depth 4)
Now, let's see how GBM performs with deeper trees, each having a depth of 4.


{{< rawhtml >}}
<center>
<div class="container">
        <div class="info">
            <h3 id="stepInfo2">Initial Prediction (Base Value)</h3>
            <div id="details"></div>
        </div>
        <canvas id="plotCanvas2" width="1000" height="700"></canvas>
        <div class="controls">
            <button id="prevBtn2" disabled>Previous Step</button>
            <button id="nextBtn2">Next Step</button>
            <button id="resetBtn2">Reset</button>
        </div>
		<input type="range" min="0" max="50" value="0" class="slider" id="myRange2">

    </div>
</center>  
{{< /rawhtml >}}


### Observations and Considerations
By comparing the two visualizations, you'll notice a significant difference. 
With trees of depth 4, the model captures the underlying pattern much more effectively, resulting in a smaller loss. 
This demonstrates how increasing tree depth allows GBM to model more complex relationships in the data.

Luigi


{{< rawhtml >}}

 <script>

let modelData1 = null;
let modelData2 = null;
let currentStep1 = 0;
let currentStep2 = 0;
let maxStep1 = 0;
let maxStep2 = 0;

// Canvas and context for the first dataset
const canvas1 = document.getElementById('plotCanvas');
const ctx1 = canvas1.getContext('2d');

// Canvas and context for the second dataset
const canvas2 = document.getElementById('plotCanvas2');
const ctx2 = canvas2.getContext('2d');

// UI elements for the first plot
const nextBtn1 = document.getElementById('nextBtn');
const prevBtn1 = document.getElementById('prevBtn');
const resetBtn1 = document.getElementById('resetBtn');
const stepInfo1 = document.getElementById('stepInfo');
const range1 = document.getElementById('myRange');

// UI elements for the second plot
const nextBtn2 = document.getElementById('nextBtn2');
const prevBtn2 = document.getElementById('prevBtn2');
const resetBtn2 = document.getElementById('resetBtn2');
const stepInfo2 = document.getElementById('stepInfo2');
const range2 = document.getElementById('myRange2');

const details = document.getElementById('details');

// Constants for plotting
const padding = 50;
const xAxisLength = canvas1.width - 2 * padding;
const yAxisLength = canvas1.height - 2 * padding;

// Load first dataset
async function loadData1() {
    try {
        const response = await fetch('gbm_predictions.json');
        modelData1 = await response.json();
        maxStep1 = modelData1.residual_predictions.length;
        
        range1.max = maxStep1;
        initializePlot(canvas1, ctx1, modelData1, currentStep1);
        updateStepInfo1();
    } catch (error) {
        console.error('Error loading gbm_predictions.json:', error);
    }
}

// Load second dataset
async function loadData2() {
    try {
        const response = await fetch('gbm_predictions1.json');
        modelData2 = await response.json();
        maxStep2 = modelData2.residual_predictions.length;
        
        range2.max = maxStep2;
        initializePlot(canvas2, ctx2, modelData2, currentStep2);
        updateStepInfo2();
    } catch (error) {
        console.error('Error loading gbm_predictions1.json:', error);
    }
}

// Initialize plot
function initializePlot(canvas, ctx, modelData, step) {
    drawAxes(ctx, canvas);
    plotData(ctx, canvas, modelData, step);
}

// Draw axes
function drawAxes(ctx, canvas) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.lineWidth = 2;
    ctx.strokeStyle = '#000';

    // X-axis
    ctx.beginPath();
    ctx.moveTo(padding, canvas.height - padding);
    ctx.lineTo(canvas.width - padding, canvas.height - padding);
    ctx.stroke();
    
    // Y-axis
    ctx.beginPath();
    ctx.moveTo(padding, padding);
    ctx.lineTo(padding, canvas.height - padding);
    ctx.stroke();
    
    ctx.font = "bold 24px Arial";
    ctx.fillText('X', canvas.width - padding + 10, canvas.height - padding + 5);
    ctx.fillText('Y', padding - 15, padding - 10);
}

// Map X and Y coordinates
function mapXToCanvas(x) {
    return padding + (x / 10) * xAxisLength;
}

function mapYToCanvas(y) {
    const minY = -2, maxY = 2;
    return canvas1.height - padding - ((y - minY) / (maxY - minY)) * yAxisLength;
}

// Plot points and lines
function plotPoints(ctx, x, y, color, radius = 2) {
    if (!x || !y) return;
    ctx.fillStyle = color;
    for (let i = 0; i < x.length; i++) {
        ctx.beginPath();
        ctx.arc(mapXToCanvas(x[i]), mapYToCanvas(y[i]), radius, 0, 2 * Math.PI);
        ctx.fill();
    }
}

function plotLine(ctx, x, y, color, width = 2, dashed = false) {
    if (!x || !y) return;
    ctx.strokeStyle = color;
    ctx.lineWidth = width;
    ctx.setLineDash(dashed ? [5, 3] : []);
    
    ctx.beginPath();
    ctx.moveTo(mapXToCanvas(x[0]), mapYToCanvas(y[0]));
    for (let i = 1; i < x.length; i++) {
        ctx.lineTo(mapXToCanvas(x[i]), mapYToCanvas(y[i]));
    }
    ctx.stroke();
    ctx.setLineDash([]);  
}

// Plot true function
function plotTrueFunction(ctx) {
    const points = 100;
    const x = Array.from({ length: points }, (_, i) => i * (10 / (points - 1)));
    const y = x.map(val => Math.sin(val));
    plotLine(ctx, x, y, 'gray', 1);
}

// Plot data for a specific step
function plotData(ctx, canvas, modelData, step) {
    if (!modelData) return;

    drawAxes(ctx, canvas);

    plotPoints(ctx, modelData.X1, modelData.y1, 'black', 3);
    plotTrueFunction(ctx);

    ctx.font = "bold 24px Arial";
    ctx.textAlign = "center";

    if (step === 0) {
        const baseValue = Array(modelData.X1.length).fill(modelData.predictions[0][0]);
        plotLine(ctx, modelData.X1, baseValue, 'blue', 2);
        ctx.fillStyle = "blue";
        ctx.fillText("F0", canvas.width / 2, padding + 30);
    } else {
        plotLine(ctx, modelData.X1, modelData.residual_predictions[step - 1], 'green', 2);
        plotLine(ctx, modelData.X1, modelData.predictions[step], 'blue', 3);
        
        ctx.fillStyle = "blue";
        ctx.fillText(`F${step} = F${step-1} + 0.1 × γ${step}`, canvas.width / 2, padding + 60);
        ctx.fillStyle = "green";
        ctx.fillText(`γ${step}`, canvas.width / 2, padding + 30);
    }
}

// Update step information
function updateStepInfo1() {
    prevBtn1.disabled = (currentStep1 <= 0);
    nextBtn1.disabled = (currentStep1 >= maxStep1);
    stepInfo1.textContent = `Step ${currentStep1} of ${maxStep1}`;
}

function updateStepInfo2() {
    prevBtn2.disabled = (currentStep2 <= 0);
    nextBtn2.disabled = (currentStep2 >= maxStep2);
    stepInfo2.textContent = `Step ${currentStep2} of ${maxStep2}`;
}

// Event listeners for first plot
nextBtn1.addEventListener('click', () => {
    if (currentStep1 < maxStep1) {
        currentStep1++;
        range1.value = currentStep1;
        plotData(ctx1, canvas1, modelData1, currentStep1);
        updateStepInfo1();
    }
});

prevBtn1.addEventListener('click', () => {
    if (currentStep1 > 0) {
        currentStep1--;
        range1.value = currentStep1;
        plotData(ctx1, canvas1, modelData1, currentStep1);
        updateStepInfo1();
    }
});

// Event listeners for second plot
nextBtn2.addEventListener('click', () => {
    if (currentStep2 < maxStep2) {
        currentStep2++;
        range2.value = currentStep2;
        plotData(ctx2, canvas2, modelData2, currentStep2);
        updateStepInfo2();
    }
});

prevBtn2.addEventListener('click', () => {
    if (currentStep2 > 0) {
        currentStep2--;
        range2.value = currentStep2;
        plotData(ctx2, canvas2, modelData2, currentStep2);
        updateStepInfo2();
    }
});

range2.addEventListener('input', () => {
    currentStep2 = parseInt(range2.value);
    plotData(ctx2, canvas2, modelData2, currentStep2);
    updateStepInfo2();
});

range1.addEventListener('input', () => {
    currentStep1 = parseInt(range1.value);
    plotData(ctx1, canvas1, modelData1, currentStep1);
    updateStepInfo1();
});


range1.value = 0;
range2.value = 0;
// Initialize
loadData1();
loadData2();




  </script>
{{< /rawhtml >}}


