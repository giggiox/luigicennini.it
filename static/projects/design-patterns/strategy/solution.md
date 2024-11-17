{{< rawdetails title="strategy">}}

## Problem
We want to choose algorithms at runtime.
For example we can have a `Shop` and we want to decide the discount algorithm (called with `getTotal`) at runtime.


```java
Shop s = new Shop(DISCOUNT ALGORITHM);
int total = s.getTotal(100);
System.out.println(total); // prints 90
```


## Solution
{{< rawdetails title="1. use an enum">}}
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


{{< rawdetails title="2. use strategy pattern">}}
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


## Notes
{{< rawdetails title="class diagram">}}
![](/projects/design-patterns/strategy/strategy.png)
{{< endrawdetails >}}


{{< rawdetails title="strategy & visitor">}}
See this section on visitor pattern.
{{< endrawdetails >}}



{{< endrawdetails >}}
