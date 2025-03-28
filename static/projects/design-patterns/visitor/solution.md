{{< rawdetails title="visitor">}}


{{< rawdetails title="problem description">}}

You have one (or more) class(es) where you want to add a new functionality.
For example you have a `Dot` class and a `Circle` class, like this:
```java
interface Shape {
    public void draw ();
}

class Dot implements Shape{
    float x = 5, y = 8;
    public void draw () { }
}

class Circle implements Shape{
    float radius;
    public void draw () { }
}
```

Now you want to add an `export` functionality.
You can do it in two ways.
{{< endrawdetails >}}


{{< rawdetails title="solution 1. adding `export` functionality directly inside the 2 classes (good)">}}
```java
interface Shape {
    public void draw ();
	public void export ();
}

class Dot implements Shape {
    float x = 5, y = 8;
    public void draw () { }
	public void export () {
		System.out.println("Exporting Dot, x = " + d.x + ", y = " + d.y);
	}
}

class Circle implements Shape{
    float radius = 7;
    public void draw () { }
	public void export () {
		System.out.println("Exporting Circle, radius = " + radius);
	}
}

public class Client {
	public static void main(String[] args) {
		Shape dot = new Dot();
		dot.export(); 
		// outputs correctly: Exporting Dot, x = 5.0, y = 8.0
	
	    Shape [] shapeArray = new Shape[] {new Circle(), new Dot()};
	    for(Shape shape: shapeArray){
	        shape.export();
	    }
		// outputs correctly: 
		// Exporting Circle, radius = 7.0
		// Exporting Dot, x = 5.0, y = 8.0
	    
	}
}
```

This one works fine, but we have modified the code of `Shape` and `Dot`. What if we do not want to do that?

{{< endrawdetails >}}

{{< rawdetails title="solution 2. adding new class handling `export` functionality for all shapes (bad)">}}

```java

// Not touching Shapes
interface Shape {
    public void draw ();
}

class Dot implements Shape {
    float x = 5, y = 8;
    public void draw (){ }
}

class Circle implements Shape {
    float radius;
    public void draw (){ }
}

class Exporter {
    void export(Shape s) {
        System.out.println("Exporting Shape");
    }
    void export(Dot d) {
        System.out.println("Exporting Dot, x = " + d-x + ", d.y = " + y);
    }
    void export(Circle c) {
        System.out.println("Exporting Circle, radius = " + c.radius);
    }
}

public class Client {
	public static void main(String[] args) {
	    Shape s = new Dot(); 
	    Exporter ex = new Exporter();
	    ex.export(s);
		// outputs INcorrectly: Exporting Shape
	    	    
	    Shape [] shapeArray = new Shape[] {new Circle(), new Dot()};
	    for(Shape shape: shapeArray){
	        ex.export(shape);
	    }
		// outputs INcorrectly: 
		// Exporting Shape
		// Exporting Shape
	}
}
```

You can see that in this case it **does not work**. 
Pay attention, it's obvious that if you do
```
Dot s = new Dot();
Exporter ex = new Exporter();
ex.export(s);
```
This one will output correctly `Exporting Dot, x = 5.0, y = 8.0` because at static time we know that the shape is of type `Dot`.
{{< endrawdetails >}}


{{< rawdetails title="solution 2. using visitor pattern  (good)">}}


```java
interface Shape {
    public void draw ();
    public void accept(ExportVisitor visitor);
}

class Dot implements Shape{
    float x = 5, y = 8;
    public void draw (){ }
    
    public void accept(ExportVisitor visitor){
        visitor.visit(this);
    }
}

class Circle implements Shape{
    float radius = 8;
    public void draw (){ }
    
    public void accept(ExportVisitor visitor){
        visitor.visit(this);
    }
}

class ExportVisitor {
    void visit(Dot d){
        System.out.println("Exporting Dot, x = " + d.x + ", y = " + d.y);
    }
    void visit(Circle c){
        System.out.println("Exporting Circle, radius = " + c.radius);
    }
}


public class Client{
	public static void main(String[] args) {
		
		Shape s = new Dot(); 
	    ExportVisitor ex = new ExportVisitor();
	    s.accept(ex);
		// outputs correctly: Exporting Dot, x = 5.0, y = 8.0
	    	    
	    Shape [] shapeArray = new Shape[] {new Circle(), new Dot()};
	    for(Shape shape: shapeArray){
	        shape.accept(ex);
	    }
		// outputs correctly: 
		// Exporting Circle, radius = 7.0
		// Exporting Dot, x = 5.0, y = 8.0
	}
}
```

Notice how we are in fact changing the `Dot` and `Circle` code, but notice how the numbers of line changed inside a class is always constant, because you only just need to accept the visitor, whereas the Visitor logic might be big (now it's just printing).

{{< endrawdetails >}}


{{< rawdetails title="notes">}}

{{< rawdetails title="adding another operation with visitor">}}

You might be thinking that if you need to add another operation, for example a `Transform` operation, You have to
1. Create `TransformVisitor`
2. Add an accept(TransformVisitor) inside all shapes.

But this **is not** the case, you can just abstract all the visitors in an interface and create just 1 accept method for all visitors, like this:


```java
Shape s = new Dot(); 
ExportVisitor ex = new ExportVisitor();
TransformVisitor tr = new TransformVisitor();
s.accept(ex);
s.accept(tr);
// outputs correctly: 
// Exporting Dot, x = 5.0, y = 8.0
// Transforming Dot, 2*x = 10.0, 2*y = 16.0
	    	    
Shape [] shapeArray = new Shape[] {new Circle(), new Dot()};
for(Shape shape: shapeArray){
	shape.accept(ex);
	shape.accept(tr);
}
// outputs correctly: 
// Exporting Circle, radius = 7.0
// Transforming Circle, 2*radius = 16.0
// Exporting Dot, x = 5.0, y = 8.0
// Transforming Dot, 2*x = 10.0, 2*y = 16.0
```



```java
interface Shape {
    public void draw ();
    public void accept(Visitor visitor); // Notice how now it accepts a Visitor (not a specific one)
}

class Dot implements Shape{
    float x = 5, y = 8;
    public void draw (){ }
    
    public void accept(Visitor visitor){
        visitor.visit(this);
    }
}

class Circle implements Shape{
    float radius = 8;
    public void draw (){ }
    
    public void accept(Visitor visitor){
        visitor.visit(this);
    }
}


interface Visitor {
    void visit (Dot d);
    void visit (Circle c);
}

class ExportVisitor implements Visitor{
    public void visit(Dot d){
        System.out.println("Exporting Dot, x = " + d.x + ", y = " + d.y);
    }
    public void visit(Circle c){
        System.out.println("Exporting Circle, radius = " + c.radius);
    }
}

class TransformVisitor implements Visitor{
    public void visit(Dot d){
        System.out.println("Tranforming Dot, 2*x = " + (2*d.x) + ", 2*y = " + (2*d.y));
    }
    public void visit(Circle c){
        System.out.println("Tranforming Circle, 2*radius = " + (2*c.radius));
    }
}

public class Client{
	public static void main(String[] args) {
		
	}
}
```

{{< endrawdetails >}}


{{< rawdetails title="class diagram">}}
The architecture described above is reflected in the class diagram below:

{{< rawhtml >}}
<pre class="graphviz">
digraph G {
    bgcolor="#f8f9fa"
    node [
        fontname="Helvetica,Arial,sans-serif"
        shape=record
        style=filled
        fillcolor=gray95
    ]

    Element [ 
        label="{
            «interface»\n
            Element
            |
            method()\l
            visit(Visitor)\l
        }",
        pos="4,0!"
    ]

    ConcreteElement1 [ 
        label="{
            ConcreteElement1
            |
            method()\l
            accept(Visitor)\l
        }",
        pos="2.5,-2!"
    ]

    ConcreteElement2 [ 
        label="{
            ConcreteElement2
            |
            method()\l
            accept(Visitor)\l
        }",
        pos="6,-2!"
    ]
    
    Visitor [ 
        label="{
            «interface»\n
            Visitor
            |
            visit(ConcreteElement1)\l
            visit(ConcreteElement2)\l
        }",
        pos="9,0!"
    ]
    
    ConcreteVisitor [ 
        label="{
            ConcreteVisitor
            |
            visit(ConcreteElement1)\l
            visit(ConcreteElement2)\l
        }",
        pos="9,-2!"
    ]

  

    ConcreteElement1 -> Element [style=dashed, arrowhead="empty"];
    ConcreteElement2 -> Element [style=dashed, arrowhead="empty"];
    ConcreteVisitor -> Visitor [style=dashed, arrowhead="empty"];
    Element -> Visitor [style=dashed, arrowhead="vee", label="use"];


}
</pre>
{{< /rawhtml >}}


<!-- {{< includeImage path="/projects/design-patterns/visitor/visitor.png" >}} -->

{{< endrawdetails >}}




{{< rawdetails title="strategy & visitor">}}
They both delegate the an operation to an extern object.
The class diagrams are the following:



<pre class="graphviz">
digraph G {
    bgcolor="#f8f9fa"
    node [
        fontname="Helvetica,Arial,sans-serif"
        shape=record
        style=filled
        fillcolor=gray95
    ]

    Element [ 
        label="{
            «interface»\n
            Element
            |
            method()\l
            visit(Visitor)\l
        }",
        pos="4,0!"
    ]

    ConcreteElement1 [ 
        label="{
            ConcreteElement1
            |
            method()\l
            accept(Visitor)\l
        }",
        pos="2.5,-2!"
    ]

    ConcreteElement2 [ 
        label="{
            ConcreteElement2
            |
            method()\l
            accept(Visitor)\l
        }",
        pos="6,-2!"
    ]
    
    Visitor [ 
        label="{
            «interface»\n
            Visitor
            |
            visit(ConcreteElement1)\l
            visit(ConcreteElement2)\l
        }",
        pos="9,0!"
    ]
    
    ConcreteVisitor [ 
        label="{
            ConcreteVisitor
            |
            visit(ConcreteElement1)\l
            visit(ConcreteElement2)\l
        }",
        pos="9,-2!"
    ]

  

    ConcreteElement1 -> Element [style=dashed, arrowhead="empty"];
    ConcreteElement2 -> Element [style=dashed, arrowhead="empty"];
    ConcreteVisitor -> Visitor [style=dashed, arrowhead="empty"];
    Element -> Visitor [style=dashed, arrowhead="vee", label="use"];
    
    VisitorLabel [ 
        label="{Visitor}",
        pos="6,2!"
    ]
    
    StrategyLabel [ 
        label="{Strategy}",
        pos="17,2!"
    ]
    
    
    Element1 [ 
        label="{
            Element\n
            |
            -strategy: Strategy\l
            |
            setStrategy(Strategy)\l
            elementAlgorithm()\l
        }",
        pos="15,0!"
    ]

    Strategy [ 
        label="{
            «interface»\n
            Strategy
            |
            algorithm()\l
        }",
        pos="19,0!"
    ]

    ConcreteStrategy1 [ 
        label="{
            ConcreteStrategy1
            |
            algorithm()\l
        }",
        pos="17.5,-2!"
    ]

    ConcreteStrategy2 [ 
        label="{
            ConcreteStrategy2
            |
            algorithm()\l
        }",
        pos="21,-2!"
    ]

  

    ConcreteStrategy1 -> Strategy [style=dashed, arrowhead="empty"];
    ConcreteStrategy2 -> Strategy [style=dashed, arrowhead="empty"];
    Element1 -> Strategy [arrowtail=diamond, dir=both, arrowhead=none, style=solid]; 
}
</pre>

<!-- {{< includeImage path="/projects/design-patterns/visitor/strategyvisitor.png" >}} -->



They have 2 different intent:
- **Visitor**: rapresent an operation to execute on an object structure.
- **Strategy**: rapresent different type of operations to be executed in an object.

{{< endrawdetails >}}



{{< endrawdetails >}}


{{< endrawdetails >}}

