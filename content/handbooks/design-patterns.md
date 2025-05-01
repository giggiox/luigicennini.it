---
title: "Design Patterns"
date: 2024-11-05T19:53:33+05:30
draft: false
author: "Luigi"
tags:
  - handbooks
image: /projects/design-patterns/copertina.png
summary: "A list of design patterns."
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
  // margin-left: 20px;
}

details details {
  margin-left: calc(20px * 1);
}

details details details {
	margin-left: calc(20px * 2);
}

h1 a {
	text-decoration: underline;
	cursor: pointer;
	color: blue;
}
		
body.l-mode {
	background-color: white;
	color: black;
}
body svg {
	border-radius: 20px; /* Adjust the radius as needed */
    overflow: hidden; /* Ensures the corners are clipped */
	padding: 10px;
}

body.d-mode svg .node polygon{
	stroke: #ffffff;
}

body.d-mode svg .node text{
	fill: #ffffff;
}

body.d-mode svg  polygon{
	fill: #212529;
}

body.d-mode svg .edge polygon {
    stroke: #ffffff;
}

body.d-mode svg .node > polyline{
	stroke: #ffffff;
}


body.d-mode svg path{
	stroke: #ffffff;
}

body.d-mode header svg {
	padding: 0px;
}
body.l-mode header svg {
	padding: 0px;
}

#topScroll svg {
	padding: 0px;
}

body.d-mode svg text{
	fill: #ffffff;
}

body.d-mode svg ellipse{
	fill: #212529;
	stroke: #ffffff;
}

.navbar-brand img{
	filter: none;
	mix-blend-mode: normal;
}
.featured-image img{
	filter: none;
	mix-blend-mode: normal;
}
body img{
    filter: invert(100%);
    mix-blend-mode: difference;
    background-color: #18191A; /* Questo diventa il nuovo "bianco" */
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

While working on my LeetCode solutions project [(link)](https://www.luigicennini.it/en/projects/leetcode-solutions/), I realized that collapsing solutions helped me see the big picture and compare different approaches more effectively. I applied the same idea to design patterns, presenting them in a way that's easy to scan, compare, and understand at a glance.
I will also explore some common refactoring patterns in the last part of this project.

So, dive in and explore this streamlined handbook of design patterns!



{{< rawhtml >}}
<script type="module">
  import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
</script>

<script src="https://cdn.jsdelivr.net/npm/viz.js@2.1.2/viz.js"></script>
<script src="https://cdn.jsdelivr.net/npm/viz.js@2.1.2/full.render.js"></script>

<script>




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
})

</script>

{{< /rawhtml >}}

{{< rawhtml >}}
<div id="collapse-all">
    <div class="container text-end"> 
        <div class="row">
            <div class="col-12">
                <span id="toggleAll" style="cursor: pointer;">
                    ▶ Expand All
                </span>
            </div>
        </div>
    </div>
{{< /rawhtml >}}


# Design patterns
Design patterns are reusable solutions to common software design challenges. 
They help make code more modular, maintainable, and scalable. 
In this section, we'll explore key patterns and how they solve real-world problems.


## Creational
{{< include path="/projects/design-patterns/factorymethod/solution.md" >}}
{{< include path="/projects/design-patterns/staticfactorymethod/solution.md" >}}
{{< include path="/projects/design-patterns/abstractfactory/solution.md" >}}
{{< include path="/projects/design-patterns/builder/solution.md" >}}
{{< include path="/projects/design-patterns/fluentinterface/solution.md" >}}
{{< include path="/projects/design-patterns/singleton/solution.md" >}}

## Structural
{{< include path="/projects/design-patterns/decorator/solution.md" >}}
{{< include path="/projects/design-patterns/facade/solution.md" >}}
{{< include path="/projects/design-patterns/adapter/solution.md" >}}

## Behavioral
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
const detailsElements = document.querySelectorAll("#collapse-all details");
let allExpanded = false; 

toggleLink.addEventListener("click", () => {
    allExpanded = !allExpanded;
    detailsElements.forEach(details => details.open = allExpanded);            
    toggleLink.textContent = allExpanded ? "▼ Close All" : "▶ Expand All";
});

document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll('pre.graphviz').forEach(function(pre) {
      const graphvizCode = pre.textContent;
      const viz = new Viz();
      viz.renderSVGElement(graphvizCode, { engine: 'fdp' })
        .then(function(element) {
			element.setAttribute("width", "100%");
			element.setAttribute("height", "auto");
			element.setAttribute("preserveAspectRatio", "xMidYMid meet");
			pre.parentNode.replaceChild(element, pre);
        })
        .catch(function(error) {
          console.error(error);
        });
    });
  });

</script>
{{< /rawhtml >}}





---
# Refactoring
Writing clean, maintainable code is an essential skill for any developer. 
It not only makes your code easier to understand but also helps your team collaborate more effectively. 

We'll explore three key aspects of clean code:

{{< rawdetails title="nesting">}}

Deeply nested code is hard to read and debug. 
The Linux kernel coding standard recommends [avoiding nesting deeper than three levels](https://github.com/torvalds/linux/blob/master/Documentation/process/coding-style.rst) to keep code clean and maintainable. 
Even outside kernel development, this rule is a great practice for writing intuitive, easy-to-follow code.

Here's an example of deeply nested code:

```java
void processUser(User user) {
    if (user != null) {
        if (user.hasSubscription) {
            if (user.age >= 18) {
                showFullVersion();
            } else {
                showChildrenVersion();
            }
        } else {
            throw new Exception("User needs a subscription");
        }
    } else {
        throw new Exception("No user found");
    }
}
```

**Issues:**

1. The logic is buried under multiple layers of `if-else` statements.
    
2. The "happy path" (the main logic) is hard to identify.
    
3. Adding new conditions will make the code even harder to read.
    

There are 2 main refactoring techniques: **extraction** and **inversion**.

{{< rawdetails title="extraction">}}

Break down the nested logic into smaller, reusable methods. This makes the code more modular and easier to understand.

```java
void processUser(User user) {
    validateUser(user);
    checkSubscription(user);
    showAppropriateVersion(user);
}

private void validateUser(User user) {
    if (user == null) {
        throw new Exception("No user found");
    }
}

private void checkSubscription(User user) {
    if (!user.hasSubscription) {
        throw new Exception("User needs a subscription");
    }
}

private void showAppropriateVersion(User user) {
    if (user.age >= 18) {
        showFullVersion();
    } else {
        showChildrenVersion();
    }
}
```

{{< endrawdetails >}}


{{< rawdetails title="inversion">}}
Use **guard clauses** to handle edge cases early and prioritize the "happy path."

```java
void processUser(User user) {
    if (user == null) {
        throw new Exception("No user found");
    }
    if (!user.hasSubscription) {
        throw new Exception("User needs a subscription");
    }
    if (user.age < 18) {
        showChildrenVersion();
        return;
    }
    showFullVersion();
}
```

{{< endrawdetails >}}





{{< endrawdetails >}}







{{< rawdetails title="naming">}}

There are best practices for naming, for example:

1. **Avoid Abbreviations**: Write full, descriptive names. For example, use `isPasswordLongEnough` instead of `checkPwdLen`.
    
2. **Avoid Double Negatives**: Use positive names like `isBlocked` instead of `isNotBlocked`.
    
3. **Don't Include Types in Names**: In statically typed languages, this is redundant. For example, avoid `iSpeed` or `bIsValid`.
    
4. **Avoid Redundant Prefixes**: Names like `BaseVehicle` or `AbstractPerson` add unnecessary clutter.


Example:

```java
public int calc(int a, int b, int c) {
    int res = 0;
    if (a > b) {
        res = a + c;
    } else {
        res = b + c;
    }
    return res;
}
```

Can be refactored into:

```java
public int calculateTotalBonus(int baseSalary, int performanceScore, int bonusMultiplier) {
    int totalBonus = 0;
    if (baseSalary > performanceScore) {
        totalBonus = baseSalary + bonusMultiplier;
    } else {
        totalBonus = performanceScore + bonusMultiplier;
    }
    return totalBonus;
}
```

**Improvements:**

- The method name (`calculateTotalBonus`) clearly describes its purpose.
    
- Variable names (`baseSalary`, `performanceScore`, `bonusMultiplier`) provide context.
    
- The code is now self-documenting.
    
{{< endrawdetails >}}



{{< rawdetails title="commenting">}}
While comments can be helpful, overcommenting can clutter your code and make it harder to read. 
Instead of relying on comments, aim to write code that explains itself.
Here's an example of overcommented code:

```java
bool isPrime(int number) {
    // Check if number is less than 2
    if (number < 2) {
        // If less than 2, not a prime number
        return false;
    }
    
    // At least 1 divisor must be less than square root, so we can stop here
    for (int i = 2; i < Math.sqrt(number); i++) {
        // Check if the number is divisible by i
        if (number % i == 0) {
            return false;
        }
    }
    // After all checks, if not divisible by i, number is prime
    return true;
}
```

**Issues:**

- The comments repeat what the code already says.
    
- The code is cluttered and harder to read.
    

---

### Refactoring for Better Readability

Here's the same code with fewer comments:

```java
bool isPrime(int number) {
    if (number < 2) {
        return false;
    }
    
    // At least 1 divisor must be less than square root, so we can stop here
    for (int i = 2; i < Math.sqrt(number); i++) {
        if (number % i == 0) {
            return false;
        }
    }
    
    return true;
}
```

**Improvements:**

- Only the non-obvious part (the loop condition) is commented.
    
- The code is cleaner and easier to read.
{{< endrawdetails >}}

