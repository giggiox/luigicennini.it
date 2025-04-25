---
title: "Formalizing Logical Fallacies"
date: 2025-01-21T19:53:33+05:30
draft: false
author: "Luigi"
tags:
  - blog
summary: " "
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
    
{{< /rawhtml >}}


Have you ever encountered a statement that just didn't sit right with you? 

Imagine a friend of yours comes up at you and says:

> If I carry my lucky coin, I will pass the exam. I passed the exam. Therefore, I passed because I carried my lucky coin.

You pause. Something about this assertion feels off. You instinctively respond, "That doesn't make sense", but you can't quite articulate why.

Also, what kind of friend starts a conversation like this? But let's roll with it.


What you've stumbled upon here is a **logical fallacy**.
But what exactly are logical fallacies, and how do they fit into the bigger picture of formal logic? More importantly, how can you figure out if an argument really holds?

In this blog post, we'll explore logical fallacies and their role in formal logic. By the end, you'll understand how to identify fallacies and use mathematics to prove whether an argument is sound.

## What Are Logical Fallacies?
Logical fallacies are errors in reasoning that undermine the validity of an argument. They often appear persuasive but fail when scrutinized. Recognizing these fallacies is a critical skill, especially when engaging in debates or evaluating claims.
Logical fallacies can often be identified by analyzing the structure of arguments. Formalizing these arguments in **propositional logic** or **predicate logic** allows us to apply mathematical rigor to test their validity.

## Core Theorem: Semantic-Syntactic Correspondence

To understand how to formally analyze this type of arguments we first have to know these core theorems of propositional logic.
These are the tools we'll use to untangle logical fallacies.

**Theorem 1**: $$A \vDash B \iff A \rightarrow B \text{ is a tautology.}$$

Where $A \vDash B$ means $B$ is a logical consequence of $A$.

A [tautology](https://en.wikipedia.org/wiki/Tautology_(logic)) is a a statement that is true in every possible interpretation.

**Theorem 2**: $$\set{A_1,A_2} \vDash B \iff A_1 \wedge A_2 \vDash B$$


To test whether a formula is a tautology, we'll use [truth tables](https://en.wikipedia.org/wiki/Truth_table). 

However, there's a more powerful (though computationally harder) approach: **testing satisfiability**.

**Theorem 3**: $$A \vDash B \iff A \wedge \neg B \text{ is unsatisfiable}$$

Testing whether a formula is satisfiable is a well-studied problem in computer science, known as Boolean Satisfiability (SAT). 
Advanced algorithms like the [Davis-Putnam algorithm](https://en.wikipedia.org/wiki/Davis%E2%80%93Putnam_algorithm) can handle this (sort of) efficiently.

**But let's keep things simple**. For this blog post, we'll stick to **Theorem 1** in its negated form:
$$A \rightarrow B \text{ is NOT a tautology} \implies A \nvDash B$$





## Common logical fallacies
Let's explore two common logical fallacies: **Denying the Antecedent** and **Affirming the Consequent**. We'll analyze them using both propositional and predicate logic.


## 1. Denying the Antecedent

This fallacy assumes that if the antecedent is false, the consequent must also be false. 

Consider these examples:
### 1. Propositional logic example:
>If it barks, it's a dog. It doesn't bark. Therefore, it's not a dog.

We can formalize this argument using propositional logic:
Let $P = \text{it barks}$, $\neg P = \text{ it does not bark}$ $Q = \text{it is a dog}$, $\neg Q = \text{ it is not a dog}$
Then
$$\set{P \rightarrow Q, \neg P\} \vDash \neg Q$$
Using **Theorem 2**, we test the validity:
$$(P \rightarrow Q \wedge \neg P) \rightarrow \neg Q$$
To prove this is not a tautology, construct a truth table:

| P   | Q   | $P \rightarrow Q \equiv \neg P \vee Q$ | $(P \rightarrow Q) \wedge \neg P$ | $(P \rightarrow Q \wedge \neg P) \rightarrow \neg Q$ |
| --- | --- | -------------------------------------- | --------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| T   | T   | T                                      | F                                 | T                                                                                                            |
| T   | F   | F                                      | F                                 | T                                                                                                            |
| F   | T   | T                                      | T                                 | F                                                                                                            |
| F   | F   | T                                      | T                                 | T                                                                                                            |

The truth table shows a counterexample (row 3) where the premises are true but the conclusion is false, proving invalidity.


### 2. Predicate Logic Example:
>Every dog barks. Totto doesn't bark. Therefore, Totto is not a dog.

Logical fallacies can also be formalized using predicate logic, which lets us reason about objects and their properties. While we haven't introduced predicate logic theorems here, the process is similar: we translate the argument into logical symbols and test its validity:

$$\set{ (\forall x)(P(x) \rightarrow Q(x)),\neg P(a) \} \vDash \neg Q(a)$$
And show in the same way that this is invalid: you let $P(x) = x \text{ barks}$, $Q(x) = x \text{ is a dog}$. You can find a dog that does not bark, the premises are true but the conclusion is false. Indeed there exists dog breeds such as Basenji that does not barks.
I just skimmed over many, many details, but just know that you can pretty much do the same thing for predicative logic.


#### 2.1 Predicate Logic with more complex formulas
For more complex formulas, checking whether they are tautologies is not always straightforward. 
Consider the following example:

$$(\exists x)(F(x)\wedge G(x))\wedge $$
$$\neg (\exists x)(C(x) \wedge F(x))$$
$$\vDash (\exists x)(C(x) \wedge \neg G(x))$$

It's challenging to come up with a counterexample for this statement.

Fortunately, there is a formal method to approach such cases. 
I'll briefly outline it here, and if you're curious, you can explore it further on your own. 
However, for simpler formulas, **like the ones involved in logical fallacies**, we're lucky enough to rely on **Theorem 1** without diving into these complexities.

For more intricate cases, the process involves:

1. [*Skolemization*](https://en.wikipedia.org/wiki/Skolem_normal_form): Transform the formula to eliminate existential quantifiers by introducing Skolem functions.
2. [*Constructing the Herbrand Universe*](https://en.wikipedia.org/wiki/Herbrand%27s_theorem): Generate the set of all possible ground terms for the formula.
3. [*Using the Davis-Putnam Algorithm*](https://en.wikipedia.org/wiki/Davis%E2%80%93Putnam_algorithm): Check the satisfiability of the formula in the Herbrand universe.


## 2. Affirming the Consequent

Let's get back to your friend argument:

> If I carry my lucky coin, I will pass the exam. I passed the exam. Therefore, I passed because I carried my lucky coin.

This fallacy assumes that if the consequent is true, the antecedent must also be true.
As we have discussed in the previous examples, this can be formalized using propositional logic in this way:
$$\set{P \rightarrow Q, Q\} \vDash P$$
Where in this case $P = \text{ i carry my lucky coin}$, $Q = \text{ i pass the exam}$, $\neg Q = \text{ it is not a dog}$.
Using **Theorem 2**, test the validity:
 $$(P \rightarrow Q \wedge Q) \rightarrow P$$

| P   | Q   | $P \rightarrow Q \equiv \neg P \vee Q$ | $(P \rightarrow Q) \wedge Q$ | $(P \rightarrow Q \wedge Q) \rightarrow P$ |
| --- | --- | -------------------------------------- | ---------------------------- | ------------------------------------------ |
| T   | T   | T                                      | T                            | T                                          |
| T   | F   | F                                      | F                            | T                                          |
| F   | T   | T                                      | T                            | F                                          |
| F   | F   | T                                      | F                            | T                                          |

Again, row 3 provides a counterexample, proving invalidity.



## Try formalizing fallacies yourself!
We've explored two common logical fallacies, denying the antecedent and affirming the consequent, and how to formalize them in propositional and predicate logic. 
By doing so, we've uncovered why these arguments fail to hold up under scrutiny.

But there's more to logical fallacies than just these two. 
Broadly speaking, logical fallacies fall into two categories:

1. [**Formal fallacies**](https://en.wikipedia.org/wiki/Formal_fallacy): where the error lies in the argument's logical structure (like the ones we analyzed here).
2. [**Informal fallacies**](https://en.wikipedia.org/wiki/Informal_fallacy): which involve errors in reasoning that may depend on context or language (e.g., appeals to emotion or authority).

Now it's your turn:

Can you think of a fallacy you've encountered recently?
I believe that by practicing how to spot these logical fallacies, you'll not only sharpen your ability to identify flawed reasoning but also develop stronger, more compelling arguments of your own.



Luigi