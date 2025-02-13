{{< rawdetails title="decorator">}}

{{< rawdetails title="problem description">}}
We want to add new behaviors to objects without modifying them (because we don't want to modify them or maybe we can't!).
{{< endrawdetails >}}



{{< rawdetails title="solution using decorator pattern">}}
Decorator lets you attach new behaviors to objects by placing these objects inside special wrapper objects that contain the behaviors.

```java
ConcreteComponent component = new ConcreteComponent();
Decorator decorator = new Decorator(component);
decorator.someLogic();  //outputs:
// Some logic by decorator part 1
// Some logic by Component
// Some logic by decorator part 2
decorator.someDecoratorNewLogic(); // outputs:
// I can do logic without using the decorator component
```

```java
interface Component {
	void someLogic ();
}

class ConcreteComponent implements Component{
	@Override
	public void someLogic () {
		System.out.println("Some logic by Component");
	}
}

class Decorator implements Component{
	private Component wrappee;
	
	public Decorator (Component wrappee) {
		this.wrappee = wrappee;
	}

	@Override
	public void someLogic () {
		System.out.println("Some logic by decorator part 1");
		wrappee.someLogic();
		System.out.println("Some logic by decorator part 2");
	}
	
	public void someDecoratorNewLogic () {
	    System.out.println("I can do logic without using the decorated component");
	}
}
```

{{< endrawdetails >}}





{{< rawdetails title="notes">}}

{{< rawdetails title="example class diagram">}}
{{< rawhtml >}}
<pre class="graphviz">
digraph {
    bgcolor="#f8f9fA"
    node [
        fontname="Helvetica,Arial,sans-serif"
        shape=record
        style=filled
        fillcolor=gray95
    ]

    Product [label="{
        «interface»\n
            Component
            |
            method()\l
        }",
        pos="0,1!"
    ];
    
    ConcreteComponent [
        label="{
            ConcreteComponent
            |
            method()\l
        }",
        pos="0,-1!"
    ]
    
    ConcreteDecorator [
        label="{
            ConcreteDecorator
            |
            method()\l
            newMethod()\l
        }",
        pos="3,-1!"
    ]
    

    
    ConcreteComponent -> Product [style=dashed, arrowhead="empty"];
    ConcreteDecorator -> Product [style=dashed,arrowhead="empty"]; 

}
</pre>
{{< /rawhtml >}}




<!-- {{< includeImage path="/projects/design-patterns/decorator/decorator.png" >}} -->

{{< endrawdetails >}}

{{< rawdetails title="example with multiple decorators">}}
```java
ConcreteComponent component = new ConcreteComponent();
Decorator decorator1 = new ConcreteDecorator1(component);
decorator1.someLogic();
        
Decorator decorator2 = new ConcreteDecorator2(component);
decorator2.someLogic();
```

```java
interface Component {
	void someLogic ();
}

class ConcreteComponent implements Component{
	@Override
	public void someLogic () {
		System.out.println("Some logic by Component");
	}
}


abstract class Decorator implements Component{
    
    protected Component wrappee;
    
    public Decorator (Component wrappee) {
		this.wrappee = wrappee;
	}
    
	@Override
	public void someLogic () {
	    wrappee.someLogic();
	}
}

class ConcreteDecorator1 extends Decorator{
    
    public ConcreteDecorator1 (Component wrappee) {
        super(wrappee);
    }
	
	@Override
	public void someLogic () {
		System.out.println("Some logic by Decorator1 part 1");
		wrappee.someLogic();
		System.out.println("Some logic by Decorator1 part 2");
	}
}

class ConcreteDecorator2 extends Decorator{
    
    public ConcreteDecorator2 (Component wrappee) {
        super(wrappee);
    }
	
	@Override
	public void someLogic () {
		System.out.println("Some different logic by Decorator2 part 1");
		wrappee.someLogic();
		System.out.println("Some different logic by Decorator2 part 2");
	}
}
```
{{< endrawdetails >}}


{{< rawdetails title="class diagram">}}

{{< rawhtml >}}
<pre class="graphviz">
digraph {
    bgcolor="#f8f9fA"
    node [
        fontname="Helvetica,Arial,sans-serif"
        shape=record
        style=filled
        fillcolor=gray95
    ]

    // Define nodes (classes) with explicit positions
    Product [label="{
        «interface»\n
            Component
            |
            method()\l
        }",
        pos="0,1!"
    ];
    
    ConcreteComponent [
        label="{
            ConcreteComponent
            |
            method()\l
        }",
        pos="0,-1!"
    ]
    
    Decorator [
        label="{
            «abstract»\n
            Decorator
            |
            method()\l
            newMethod()\l
        }",
        pos="3,-1!"
    ]
    
    ConcreteDecorator1 [
        label="{
            ConcreteDecorator1
            |
            method()\l
            newMethod1()\l
        }",
        pos="2,-3!"
    ]
    
    ConcreteDecorator2 [
        label="{
            ConcreteDecorator2
            |
            method()\l
            newMethod1()\l
        }",
        pos="5,-3!"
    ]
    

    
    ConcreteComponent -> Product [style=dashed, arrowhead="empty"];
    Decorator -> Product [style=dashed,arrowhead="empty"];
    ConcreteDecorator1 -> Decorator [arrowhead="empty"]; 
    ConcreteDecorator2 -> Decorator [arrowhead="empty"]; 
}
</pre>
{{< /rawhtml >}}




<!-- {{< includeImage path="/projects/design-patterns/decorator/decorator1.png" >}} -->
{{< endrawdetails >}}

{{< endrawdetails >}}


{{< endrawdetails >}}
