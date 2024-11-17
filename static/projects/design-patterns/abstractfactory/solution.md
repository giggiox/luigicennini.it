{{< rawdetails title="abstract factory">}}

## Problem
Provide an interface to create family of objects, without specifying directly the class.

## Solution


{{< rawdetails title="using abstract factory pattern">}}

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



## Notes
{{< rawdetails title="example class diagram">}}
![](/projects/design-patterns/abstractfactory/abstractfactory.png)
{{< endrawdetails >}}


{{< rawdetails title="textbook class diagram">}}
![](/projects/design-patterns/abstractfactory/abstractfactory1.png)
{{< endrawdetails >}}


{{< endrawdetails >}}
