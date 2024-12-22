{{< rawdetails title="fluent interface">}}

{{< rawdetails title="problem description">}}
We want a readable way to interact with an API.
{{< endrawdetails >}}

{{< rawdetails title="solution using fluent interface pattern">}}
```java
class Car {
    private String engine;
    private String transmission;
    private int airbags;

    public Car (String engine) { 
        this.engine = engine;
    }
    
    public Car transmission (String transmission) {
        this.transmission = transmission;
        return this;
    }
    
    public Car airbags (int airbags) {
        this.airbags = airbags;
        return this;
    }

    
    @Override
    public String toString () {
        return "Car [engine=" + engine + ", transmission=" + transmission + ", airbags=" + airbags + "]";
    }
}

public class Client {
    public static void main (String[] args) {
        Car car = new Car("V6")
                        .transmission("Automatic")
                        .airbags(4);

        System.out.println(car);
		// Prints: Car [engine=V6, transmission=Automatic, airbags=4]
    }
}

```

{{< endrawdetails >}}

{{< endrawdetails >}}
