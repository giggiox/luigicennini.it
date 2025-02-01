{{< rawdetails title="abstract factory">}}


{{< rawdetails title="problem description">}}
Provide an interface to create family of objects, without specifying directly the class.
{{< endrawdetails >}}


{{< rawdetails title="solution using abstract factory pattern">}}

```java
VehicleFactory carFactory = new CarFactory();
VehicleFactory bikeFactory = new BikeFactory();

Vehicle myCar = carFactory.createVehicle();
Vehicle myBike = bikeFactory.createVehicle();

myCar.getType();   // "Car"
myBike.getType();  // "Bike"
```

```java
interface Vehicle {
    String getType();
}

class Car implements Vehicle {
    @Override
    public String getType() {
        return "Car";
    }
}

class Bike implements Vehicle {
    @Override
    public String getType() {
        return "Bike";
    }
}

abstract class VehicleFactory {
    abstract Vehicle createVehicle();
}

class CarFactory extends VehicleFactory {
    @Override
    Vehicle createVehicle() {
        return new Car();
    }
}

class BikeFactory extends VehicleFactory {
    @Override
    Vehicle createVehicle() {
        return new Bike();
    }
}
```
{{< endrawdetails >}}



{{< rawdetails title="notes">}}

{{< rawdetails title="example class diagram">}}




{{< rawhtml >}}
<pre class="graphviz">



digraph {
    bgcolor="#f8f9fa"
    node [
        fontname="Helvetica,Arial,sans-serif"
        shape=record
        style=filled
        fillcolor=gray95
    ]

    // Define nodes (classes) with explicit positions
    Product [label="{
        «interface»\n
            Product
        }",
        pos="0,1!"
    ];
    
    ConcreteProduct1 [
        label="{
            ConcreteProduct1
        }",
        pos="-1,0!"
    ]
    
    ConcreteProduct2 [
        label="{
            ConcreteProduct2
        }",
        pos="1,0!"
    ]
    
    
    AbstractFactory [label="{
        «abstract»\n
            AbstractFactory
        |
        Product createProduct()
        }",
        pos="6,1!"
    ];
    
    ConcreteFactory1 [label="{
            ConcreteFactory1
        |
        ConcreteProduct1 createProduct()
        }",
        pos="4,-1!"
    ]
    
    ConcreteFactory2 [label="{
            ConcreteFactory2
        |
        ConcreteProduct2 createProduct()
        }",
        pos="8,-1!"
    ]
    
    ConcreteProduct1 -> Product [style=dashed, arrowhead="empty"];
    ConcreteProduct2 -> Product [style=dashed, arrowhead="empty"]; 
    
    ConcreteFactory1 -> AbstractFactory [arrowhead="empty"];
    ConcreteFactory2 -> AbstractFactory [arrowhead="empty"];
}
</pre>
{{< /rawhtml >}}





<!-- {{< includeImage path="/projects/design-patterns/abstractfactory/abstractfactory.png" >}} -->
{{< endrawdetails >}}


{{< rawdetails title="textbook class diagram">}}


<pre class="graphviz">
digraph {
    bgcolor="#f8f9fa"
    node [
        fontname="Helvetica,Arial,sans-serif"
        shape=record
        style=filled
        fillcolor=gray95
    ]

    ProductA [label="{
        «interface»\n
            ProductA
        }",
        pos="0,1!"
    ];
    
    ConcreteProductA1 [
        label="{
            ConcreteProductA1
        }",
        pos="-1,0!"
    ]
    
    ConcreteProductA2 [
        label="{
            ConcreteProductA2
        }",
        pos="1,0!"
    ]
    
    
    ProductB [label="{
        «interface»\n
            ProductB
        }",
        pos="0,-2!"
    ];
    
    ConcreteProductB1 [
        label="{
            ConcreteProductB1
        }",
        pos="-1,-4!"
    ]
    
    ConcreteProductB2 [
        label="{
            ConcreteProductB2
        }",
        pos="1,-4!"
    ]
    
    
    AbstractFactory [label="{
        «abstract»\n
            AbstractFactory
        |
        Product createProductA()\l
        Product createProductB()\l
        }",
        pos="8,1!"
    ];
    
    ConcreteFactory1 [label="{
            ConcreteFactory1
        |
        ConcreteProductA1 createProductA()\l
        ConcreteProductB1 createProductB()\l
        }",
        pos="6,-1!"
    ]
    
    ConcreteFactory2 [label="{
            ConcreteFactory2
        |
        ConcreteProductA2 createProductA()\l
        ConcreteProductB2 createProductB()\l
        }",
        pos="10,-1!"
    ]
    
    ConcreteProductA1 -> ProductA [style=dashed, arrowhead="empty"];
    ConcreteProductA2 -> ProductA [style=dashed, arrowhead="empty"]; 
    ConcreteProductB1 -> ProductB [style=dashed, arrowhead="empty"];
    ConcreteProductB2 -> ProductB [style=dashed, arrowhead="empty"]; 
    
    ConcreteFactory1 -> AbstractFactory [arrowhead="empty"];
    ConcreteFactory2 -> AbstractFactory [arrowhead="empty"];
}
</pre>

<!--  {{< includeImage path="/projects/design-patterns/abstractfactory/abstractfactory1.png" >}} -->
{{< endrawdetails >}}

{{< endrawdetails >}}



{{< endrawdetails >}}
