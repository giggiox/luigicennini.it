{{< rawdetails title="builder">}}


## Problem
Suppose you have a complex object to build, you can do that in many ways:

{{< rawdetails title="1. Overloading the constructor">}}

```java
class Car {
	private String engine; // This is not optional
    private String transmission; // This is optional
    private int airbags; // This is optional
	
	Car (String engine) { ... }
	Car (String engine, String transmission) { ... }
	Car (String engine, String transmission, int airbags) { ... }
}
```
{{< endrawdetails >}}

You can see that as the complexity of the object grows, the constructor gets crammed with more and more parameters, which is not optimal.

{{< rawdetails title="2. Using setters">}}
```java
Car car = new Car("V8");
car.setTransmission("automatic");
car.setAirbags(5);
```
{{< endrawdetails >}}

Again this is not optimal with complex objects.


## Solution

{{< rawdetails title="3. using builder pattern">}}

The builder pattern propose a solution to this problem, where the construction of the object is handled by (usually) a private static class inside the object itself.
So to build the `Car` object you will do something like this

```java
Car car = new Car.CarBuilder("V6")
	.withTransmission("Automatic")
	.withAirbags(4)
	.build();

System.out.println(car);
// Prints: Car [engine=V6, transmission=Automatic, airbags=4]
```

The code to do so is the following:

```java
class Car {
    private String engine; // This is not optional
    private String transmission; // This is optional
    private int airbags; // This is optional

    // Private constructor only accessible by builder
    private Car () { }

    public static class CarBuilder {
        private String engine;
        private String transmission = "Manual"; // Default value
        private int airbags = 2;

        public CarBuilder (String engine) {
            this.engine = engine; // This way we are enforcing the car to have at least a motor (the non optional field)
        }
        public CarBuilder withTransmission (String transmission) {
            this.transmission = transmission;
            return this;
        }

        public CarBuilder withAirbags (int airbags) {
            this.airbags = airbags;
            return this;
        }

        public Car build () {
            Car car = new Car(); // It can access private member
            car.engine = engine;
            car.transmission = transmission;
            car.airbags = airbags;
            return car;
        }
    }
    
    @Override
    public String toString () {
        return "Car [engine=" + engine + ", transmission=" + transmission + ", airbags=" + airbags + "]";
    }
}
```

Notice how:
- The constructor of the `Car` class is kept private. Only the Builder class can call it.
- The non optional parameters of the constructed class has to be passed to the builder class.
- The builder class has the same exact variables as the `Car` class.

{{< endrawdetails >}}



{{< endrawdetails >}}
