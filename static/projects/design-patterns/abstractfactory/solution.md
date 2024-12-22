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
{{< includeImage path="/projects/design-patterns/abstractfactory/abstractfactory.png" >}}
{{< endrawdetails >}}


{{< rawdetails title="textbook class diagram">}}
{{< includeImage path="/projects/design-patterns/abstractfactory/abstractfactory1.png" >}}
{{< endrawdetails >}}

{{< endrawdetails >}}



{{< endrawdetails >}}
