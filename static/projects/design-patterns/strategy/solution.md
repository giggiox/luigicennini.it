{{< rawdetails title="strategy (and dependency injection)">}}

{{< rawdetails title="problem description">}}
We want to choose algorithms at runtime.
For example we can have a `Shop` and we want to decide the discount algorithm (called with `getTotal`) at runtime.
```java
Shop s = new Shop();
int total = s.getTotal(100);
System.out.println(total); // prints 90 because we are applying a discount of 10%
```
{{< endrawdetails >}}



{{< rawdetails title="solution 1. use an enum (bad)">}}
```java
Shop s = new Shop(DiscountType.ABSOLUTE_DISCOUNT);
int total = s.getTotal(100);
System.out.println(total); // prints 90
```


```java
enum DiscountType {
    NO_DISCOUNT,
    ABSOLUTE_DISCOUNT,
    PERCENTAGE_DISCOUNT
}

class Shop {
    private DiscountType dt;
    
    public int absoluteDiscount = 10;
    public int percentageDiscount = 20;
    
    public Shop (DiscountType dt) {
        this.dt = dt;
    }
    
    public void setDiscountType (DiscountType dt) {
        this.dt = dt;
    }
    
    public int getTotal (int originalPrice) {
        switch (dt) {
            case NO_DISCOUNT:
                return originalPrice;
            case ABSOLUTE_DISCOUNT:
                return originalPrice - absoluteDiscount;
            case PERCENTAGE_DISCOUNT:
                return originalPrice - (originalPrice*100/percentageDiscount);
        }
        return 0;
    }
    
}
```
{{< endrawdetails >}}


{{< rawdetails title="solution 2. use strategy pattern (good)">}}
```java
DiscountStrategy ds = new AbsoluteDiscountStrategy(10);
Shop s = new Shop(ds);
int total = s.getTotal(100);
System.out.println(total); // prints 90
```

```java
interface DiscountStrategy {
    int applyDiscount (int originalPrice);
}

class NoDiscountStrategy implements DiscountStrategy {
    @Override
    public int applyDiscount (int originalPrice) {
        return originalPrice;
    }
}

class AbsoluteDiscountStrategy implements DiscountStrategy {
    
    private int discount;
    
    public AbsoluteDiscountStrategy (int discount) {
        this.discount = discount;
    }
    
    @Override
    public int applyDiscount (int originalPrice) {
        return originalPrice - discount;
    }
}

class PercentaceDiscountStrategy implements DiscountStrategy {
    private int percentage;
    
    public PercentaceDiscountStrategy (int percentage) {
        this.percentage = percentage;
    }
    
    @Override
    public int applyDiscount (int originalPrice) {
        return originalPrice - (originalPrice - originalPrice*percentage/100);
    }
}

class Shop {
    private DiscountStrategy ds;
    
    public Shop (DiscountStrategy ds) {
        this.ds = ds;
    }
    
    public void setDiscountStrategy (DiscountStrategy ds) {
        this.ds = ds;
    }
    
    public int getTotal (int originalPrice) {
        return ds.applyDiscount(originalPrice);
    }
    
}

```
{{< endrawdetails >}}





{{< rawdetails title="notes">}}

{{< rawdetails title="class diagram">}}
![](/projects/design-patterns/strategy/strategy.png)
{{< endrawdetails >}}


{{< rawdetails title="dependency injection">}}
The difference between Strategy and Dependency Injection is little and is about what they are trying to achieve. 
The Strategy pattern is used in situations where you know that you want to swap out implementations. 
As an example, you might want to format data in different ways - you could use the strategy pattern to swap out an XML formatter or CSV formatter, etc.

Dependency Injection is different in that the user is not trying to change the runtime behaviour. 
Following the example above, we might be creating an XML export program that uses an XML formatter. Rather than structuring the code like this:

```java
public class DataExporter() {
  XMLFormatter formatter = new XMLFormatter();
}
```
you would 'inject' the formatter in the constructor:

```java
public class DataExporter {
  IFormatter formatter = null;

  public DataExporter(IDataFormatter dataFormatter) {
    this.formatter = dataFormatter;
  }
}

DataExporter exporter = new DataExporter(new XMLFormatter());
```

{{< endrawdetails >}}



{{< rawdetails title="strategy & visitor">}}
See this section on visitor pattern.
{{< endrawdetails >}}

{{< endrawdetails >}}




{{< endrawdetails >}}
