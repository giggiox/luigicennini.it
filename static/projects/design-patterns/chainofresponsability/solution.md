{{< rawdetails title="chain of responsabilities">}}

## Problem

An object wants to pass the responsability of performing an action to a chain of other objects.

![](/projects/design-patterns/chainofresponsability/chainofresp.png)




{{< rawdetails title="using chain of responsabilities pattern">}}
Each object in the chain tries to handle the request, if it can't, the request is passed down in the chain.


```java
StringFinder finder = new EqualsStringFinder(
	new EqualsNoCaseStringFinder(
		new PrefixStringFinder(
			new SuffixStringFinder(null))));
	System.out.println(
		finder.match("hello world", "hello world"));
```


```java
abstract class StringFinder {
    private StringFinder next;
    public StringFinder (StringFinder next) {
        this.next = next;
    }

    public boolean match (String aString, String anotherString) {
        if (next != null) {
            return next.match(aString, anotherString);
        }
        return false;
    }
}

class EqualsStringFinder extends StringFinder {
    public EqualsStringFinder(StringFinder next) {
        super(next);
    }
    
    @Override
    public boolean match(String aString, String anotherString) {
        if (aString.equals(anotherString))
            return true;
        return super.match(aString, anotherString);
    }
}

class EqualsNoCaseStringFinder extends StringFinder {
    
    public EqualsNoCaseStringFinder(StringFinder next) {
        super(next);
    }
    
    @Override
    public boolean match(String aString, String anotherString) {
        if (aString.equalsIgnoreCase(anotherString))
            return true;
        return super.match(aString, anotherString);
    }
}


class PrefixStringFinder extends StringFinder {
    public PrefixStringFinder(StringFinder next) {
        super(next);
    }
    
    @Override
    public boolean match(String aString, String anotherString) {
        if (aString.startsWith(anotherString))
            return true;
        return super.match(aString, anotherString);
    }
    
} 

class SuffixStringFinder extends StringFinder {
    public SuffixStringFinder(StringFinder next) {
        super(next);
    }
    
    @Override
    public boolean match(String aString, String anotherString) {
        if (aString.endsWith(anotherString))
            return true;
        return super.match(aString, anotherString);
    }
}
```
{{< endrawdetails >}}



## Notes

{{< rawdetails title="example class diagram">}}
![](/projects/design-patterns/chainofresponsability/chainofresp1.png)
{{< endrawdetails >}}


{{< rawdetails title="implementation where the forwarding logic is implemented in the abstract class ">}}

```java
StringFinder finder = new EqualsStringFinder(
	new EqualsNoCaseStringFinder(
		new PrefixStringFinder(
			new SuffixStringFinder(null))));
	System.out.println(
		finder.match("hello world", "hello world"));
```


```java
abstract class StringFinder {
    private StringFinder next;
    public StringFinder (StringFinder next) {
        this.next = next;
    }

    public boolean match (String aString, String anotherString) {
        if (doMatch(aString, anotherString)) {
            return true;
        } else if (next != null) {
            return next.match(aString, anotherString);
        }
        return false;
    }
    
    
    protected abstract boolean doMatch (String aString, String anotherString);
}

class EqualsStringFinder extends StringFinder {
    public EqualsStringFinder(StringFinder next) {
        super(next);
    }
    
    @Override
    public boolean doMatch(String aString, String anotherString) {
        return aString.equals(anotherString);
    }
}

class EqualsNoCaseStringFinder extends StringFinder {
    
    public EqualsNoCaseStringFinder(StringFinder next) {
        super(next);
    }
    
    @Override
    public boolean doMatch(String aString, String anotherString) {
        return aString.equalsIgnoreCase(anotherString);
    }
}


class PrefixStringFinder extends StringFinder {
    public PrefixStringFinder(StringFinder next) {
        super(next);
    }
    
    @Override
    public boolean doMatch(String aString, String anotherString) {
        return aString.startsWith(anotherString);
    }
    
} 

class SuffixStringFinder extends StringFinder {
    public SuffixStringFinder(StringFinder next) {
        super(next);
    }
    
    @Override
    public boolean doMatch(String aString, String anotherString) {
        return aString.endsWith(anotherString);
    }
}
```
{{< endrawdetails >}}



{{< endrawdetails >}}
