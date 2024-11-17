{{< rawdetails title="singleton">}}

## Problem
We want to
1. Ensure a class has a single instance
2. Provide a global access point to that instance

## Solution

{{< rawdetails title="using singleton pattern">}}

```java
public class App {
	private static App instance = null;
	
	private App () { }
	
	public static App getInstance () {
		if (instance == null) {
			instance = new App();
		}
		return instance;
	}
}
```
{{< endrawdetails >}}


Notice that:
1. The constructor is private.
2. The instance field is private and **static**


{{< endrawdetails >}}
