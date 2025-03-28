---
title: "Gradient Boosting Machine & Noisy Datasets"
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

.math-container-inline {
    overflow-x: auto;
    display: block;
    max-width: 100%;
    text-align: left;
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

Curious about how Gradient Boosting Machines (GBMs) really work? I've built an interactive visualization to demystify the process!

## GBM basics
GBMs learn iteratively, focusing on the errors of previous trees. 
This incremental approach builds a powerful predictive model. 
Here's a quick visual reminder of the algorithm (from [Friedman paper in 2001](https://jerryfriedman.su.domains/ftp/trebst.pdf)):

Given a dataset ${(x_i,y_i)}_{i=1}^{n}$
{{< rawhtml >}}
<div class="math-container-inline">
{{< /rawhtml >}}
1. $F^0(x) = \underset{\gamma}{argmin} \sum_{i=1}^n L(y_i, \gamma)$
2. $\text{for } m = 1,...,M:$
	1. $r_{i,m} = - \Big[\frac{\partial L(y_i, F(x_i))}{\partial F(x_i)} \Big]_{F(x) = F^{m-1}(x)} \text{ for } i = 1,...,n$
	2. $\text{fit a regression tree to } r_{i,m} \text{ and create terminal regions for } R_{jm} \text{ for } j = 1,...,J_m$
	3. $\forall j = 1...J_m \text{ compute } \gamma_{j,m} = \underset{\gamma}{argmin} \sum_{x_i \in R_{i,j}} L(y_i, F^{m-1}(x_i) + \gamma)$
	4. $\text{update } F^m(x) = F^{m-1}(x) + \nu \sum_{j=1}^{J_m} \gamma_{j,m} I(x \in R_{j,m})$
3. $\text{output } F^M(x)$
{{< rawhtml >}}
</div>
{{< /rawhtml >}}


There are many resources online explaining the algorithm, like this one so I won't rehash it. 
Instead, let's get hands-on and see GBM in action.

## Visualizing Shallow Trees (Depth 1)
First, let's visualize GBM building $M=50$ trees, each with a depth of 1.
{{< rawhtml >}}
<center>
<div class="container">
        <div class="info">
            <h3 id="stepInfo">Initial Prediction (Base Value)</h3>
            <div id="details"></div>
        </div>
        <canvas id="plotCanvas" width="1000" height="700"></canvas>
		<br>
        <div class="controls">
            <button id="prevBtn" class="btn btn-primary" disabled>Previous Step</button>
            <button id="nextBtn" class="btn btn-primary">Next Step</button>
        </div>
		<input type="range" min="0" max="50" value="0" class="slider" id="myRange">

    </div>
</center>  
{{< /rawhtml >}}

**What you are seeing**: 
- $\gamma_i$: This represents the individual tree built on the residuals (errors) from the previous prediction.
- $F^i$: This is the updated prediction, where each new tree's contribution is added to the previous prediction, scaled by the learning rate (0.1 in this case).

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
		<br>
        <div class="controls">
            <button id="prevBtn2" class="btn btn-primary" disabled>Previous Step</button>
            <button id="nextBtn2" class="btn btn-primary">Next Step</button>
        </div>
		<input type="range" min="0" max="50" value="0" class="slider" id="myRange2">

    </div>
</center>  
{{< /rawhtml >}}


### Observations and Considerations
By comparing the two visualizations, you'll notice a significant difference. 
With trees of depth 4, the model captures the underlying pattern much more effectively, resulting in a smaller loss. 
This demonstrates how increasing tree depth allows GBM to model more complex relationships in the data.


# Why this project

And this is why i did this project:

```R
model <- gbm_fit(X4, y4, ls_objective, M = 100, learning_rate = 0.1, max_depth = 3)
predictions <- gbm_predict(model, X4)
loss <- ls_objective$loss(y4, predictions)
ggplot(data.frame(x = X4, y = y4, pred = predictions), aes(x = x)) +
  geom_point(aes(y = y), alpha = 0.5, color = "black") +
  geom_line(aes(y = pred), color = "red", size = 1) +
  labs(title = paste("noise_fractioN = 0.5, LS loss = " ,sprintf(loss, fmt = '%#.4f')), x = "X", y = "Y") +
  ylim(-6, 6) +
  theme_minimal()
```


{{< includeImage path="/blog/gbm/bad.png" >}}
You can see, it's pretty bad with noisy datasets. The default loss function (LS) does a pretty bad job.


# The role of Loss functions and noisy datasets

While playing with GBM R library i discovered that it is not possible to change the Loss function $L$.
By default it uses least squares.

The algorithm only requires the loss function do be differentiable.



## Least Squares

$$L(y,pred) = \frac{1}{2} (y-pred)^2$$

This function simplify most of the algorithm complexity, just by unwrapping the math we can see that 

$$F^0(x) = \underset{\gamma}{argmin} \sum_{i=1}^n L(y_i, \gamma) = \hat{y}$$

so we don't have to do line search.

Also for pseudo residuals

$$r_{i,m} = - \Big[\frac{\partial L(y_i, F(x_i)}{\partial F(x_i)} \Big]_{F(x) = F^{m-1}(x)}=y_i-F^{m-1}(x_i)$$



## LAD
$$L(y,pred) = |y-pred|$$
$$r_{i,m} = - \Big[\frac{\partial L(y_i, F(x_i)}{\partial F(x_i)} \Big]_{F(x) = F^{m-1}(x)}=sign(y_i-F^{m-1}(x_i))$$


## Huber loss


$$L_\delta(y,pred)=\begin{cases}
\frac{1}{2}(y-pred)^2 \text{ if } |y-pred| \leq \delta \cr
\delta(|y-pred|-\frac{1}{2}\delta) \text{ otherwise}
\end{cases}
$$

$$r_{i,m} = - \Big[\frac{\partial L(y_i, F(x_i)}{\partial F(x_i)} \Big]_{F(x) = F^{m-1}(x)} =\begin{cases}
y_i - F^{m-1}(x_i) \text{ if } |y_i-F^{m-1}(x_i)| \leq \delta \cr
\delta(sign(y_i-F^{m-1}(x_i)) \text{ otherwise}
\end{cases}$$












## Let's code it up

I coded the algorithm from scratch in R. You can see the algorithm at the end of this article

For now, just know that you can use the algorithm like this:

```R
model <- gbm_fit(X, y, loss, M = 100, learning_rate = 0.1, max_depth = 3)
predictions <- gbm_predict(model, X)
```

Where `loss` is a custom loss function.

So we can define:

1. Least Squares loss function

```R
ls_objective <- list(
  loss = function(y, pred) mean(0.5*(y - pred)^2),
  negative_gradient = function(y, pred) y - pred
)
```


2. LAD loss function
```R
abs_objective <- list(
  loss = function(y, pred) mean(abs(y - pred)),
  negative_gradient = function(y, pred) sign(y - pred)
)
```

3. Huber loss function
```R
create_huber_loss <- function(delta) {
  list(
    loss = function(y, pred) {
      error <- y - pred
      loss <- ifelse(
        abs(error) <= delta,
        0.5 * error^2,
        delta * (abs(error) - 0.5 * delta)
      )
      mean(loss)
    },
    negative_gradient = function(y, pred) {
      error <- y - pred
      grad <- ifelse(
        abs(error) <= delta,
        error,
        delta * sign(error)
      )
      grad
    }
  )
}
```

So we just need to pass those custom functions to our algorithm!

# Setting up some experiments

First off, the seed for reproducibility:

```R
set.seed(18)
```

I created 4 datasets this way:

```R
n <- 500
data <- make_test_data(n, 0.5,points_fraction)
X <- data$x
y <- data$y
```

Where `make_test_data` is a custom function (you can see this as well at the end of this article).
With `points_fraction = 0,0.1,0.3,0.5`



{{< includeImage path="/blog/gbm/datasets.png" >}}




Pretty bad right?

So i run the follwing experiments, for each loss function and datasets i tried to see what yelds to the lowest loss value possible:
For the huber loss i tried the following $\delta$ values: $0.1, 0.5, 1$.



| noise_fraction | LS    | LAD  | Huber $\delta=0.1$ | Huber $\delta=0.5$ | Huber $\delta=1$ |
|-------|-------|------|-----------------|-----------------|---------------|
|0| 0.004 | 0.07 | 0.006           | 0.004           | 0.004         |
|0.1| 0.27  | 0.24 | 0.024           | 0.08            | 0.14          |
|0.3| 1.01  | 0.69 | 0.07            | 0.29            | 0.5           |
|0.5| 1.58  | 1.01 | 0.1             | 0.43            | 0.7           |





# Notes

```R
library(rpart)
gbm_fit <- function(X, y, objective, M = 100, learning_rate = 0.1, max_depth = 1) {
  get_optimal_base_value <- function(y, loss) {
    c_values <- seq(min(y), max(y), length.out = 100)
    losses <- sapply(c_values, function(c) loss(y, rep(c, length(y))))
    c_values[which.min(losses)]
  }
  
  get_optimal_leaf_value <- function(y, current_predictions, loss) {
    if (length(y) == 0) {
      stop("No samples in this leaf. Cannot compute optimal leaf value.")
    }
    c_values <- seq(-1, 1, length.out = 100)
    losses <- sapply(c_values, function(c) loss(y, current_predictions + c))
    optimal_value <- c_values[which.min(losses)]
    return(optimal_value)
  }
  
  update_terminal_nodes <- function(tree, X, y, current_predictions, loss) {
    leaf_nodes <- which(tree$frame$var == "<leaf>")
    leaf_node_for_each_sample <- as.numeric(predict(tree, data.frame(X), type = "matrix"))
    
    for (leaf in leaf_nodes) {
      samples_in_this_leaf <- which(leaf_node_for_each_sample == leaf)
      if (length(samples_in_this_leaf) == 0) {
        next
      }
      y_in_leaf <- y[samples_in_this_leaf]
      preds_in_leaf <- current_predictions[samples_in_this_leaf]
      val <- get_optimal_leaf_value(y_in_leaf, preds_in_leaf, loss)
      tree$frame$yval[leaf] <- val
    }
    tree
  }
  
  base_prediction <- get_optimal_base_value(y, objective$loss)
  current_predictions <- rep(base_prediction, length(y))
  trees <- list()
  
  for (i in 1:M) {
    pseudo_residuals <- objective$negative_gradient(y, current_predictions)
    tree <- rpart(pseudo_residuals ~ ., data = data.frame(X, pseudo_residuals), 
                  method = "anova", maxdepth = max_depth)
    tree <- update_terminal_nodes(tree, X, y, current_predictions, objective$loss)
    current_predictions <- current_predictions + learning_rate * predict(tree, data.frame(X))
    trees[[i]] <- tree
  }
  
  list(trees = trees, base_prediction = base_prediction, learning_rate = learning_rate)
}

gbm_predict <- function(model, X) {
  predictions <- model$base_prediction + model$learning_rate * Reduce(
    `+`, lapply(model$trees, function(tree) predict(tree, data.frame(X)))
  )
  predictions
}
```



```R
make_test_data <- function(n, noise_scale, points_fraction = 0.2) {
  x <- matrix(seq(0, 10, length.out = n), ncol = 1)
  y <- sin(x) + rnorm(n, 0, 0.1)
  
  # Introduce noise
  n_points <- ceiling(n * points_fraction)
  if (n_points > 0) {
    points_indices <- sample(seq_len(n), n_points)
    y[points_indices] <- y[points_indices] + rnorm(n_points, 0, 5 * noise_scale)
  }
  
  data.frame(x = x, y = y)
}
```


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
	
	
	let pointsColor = 'black';
	if (isDarkMode){
		pointsColor = 'white';
	}
	
    ctx.strokeStyle = pointsColor;
	ctx.fillStyle = pointsColor;
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

	let pointsColor = 'black';
	if (isDarkMode){
		pointsColor = 'white';
	}
    plotPoints(ctx, modelData.X1, modelData.y1, pointsColor, 3);
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

	document.getElementById("theme-toggle").addEventListener("click", () => {
		if (document.body.className.includes("dark")) {
			isDarkMode = false;
		} else {
			isDarkMode = true;
		}
		document.body.classList.toggle('d-mode', isDarkMode);
		document.body.classList.toggle('l-mode', !isDarkMode);
		loadData1();
		loadData2();
	})




  </script>
{{< /rawhtml >}}




{{< rawhtml >}} 
<script>
document.addEventListener("DOMContentLoaded", function () {
    if (window.MathJax) {
        MathJax.startup.promise.then(() => {
            document.querySelectorAll("mjx-container.MathJax").forEach(function (el) {
                // Controlla se è un'equazione a blocco (display math)
                if (el.getAttribute("display") === "true") {
                    // Controlla se non è già avvolto in un math-container
                    if (!el.parentElement.classList.contains("math-container")) {
                        let wrapper = document.createElement("div");
                        wrapper.classList.add("math-container");

                        el.parentNode.insertBefore(wrapper, el);
                        wrapper.appendChild(el);
                    }
                }
            });
        }).catch((err) => console.error("Errore MathJax:", err));
    } else {
        console.warn("MathJax non è stato caricato.");
    }
});
</script>
{{< /rawhtml >}}


