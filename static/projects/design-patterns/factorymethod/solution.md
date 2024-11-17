{{< rawdetails title="factory method">}}

## Problem


{{< rawdetails title="see problem description">}}

Suppose you have a class `MyType` with 2 implementation `MyImpl` and `MyOtherImpl` and suppose this class is used by your application class, like this:

```java
class MyType { }

class MyImpl extends MyType { }

class MyOtherImpl extends MyType { }

class App {
	private MyType mt;
	
	public void init () {
		mt = new MyImpl();
	}
	
	public void destroy () {
		mt = new MyImpl();
	}
}
```

Now if you change what object is instantated in one of the 2 instantiation, for example in the `destroy` method, but you forget to change it in the other method, the code will work, but it won't be correct. 

```java
class App {
	private MyType mt;
	
	public void init () {
		mt = new MyImpl();
	}
	
	public void destroy () {
		mt = new MyOtherImpl(); // I change it here but i forget to change it in init
	}
}
```

It can also happen that you extends the `App` class, you override only one of the 2 method with another implementation and then you forgot to override the other.
{{< endrawdetails >}}


## Solution


{{< rawdetails title="using factory method pattern">}}

Factory method pattern propose a solution where you *refactor* your code to instantiate the object only in one part of your code, so the error could not happen.

```java
class App {
	private MyType mt;
	
	public MyType createMyType() {
		return new MyImpl();
	}
	
	public void init () {
		mt = createMyType();
	}
	
	public void destroy () {
		mt = createMyType(); // I change it here but i forget to change it in init
	}
}
```
{{< endrawdetails >}}


{{< endrawdetails >}}
