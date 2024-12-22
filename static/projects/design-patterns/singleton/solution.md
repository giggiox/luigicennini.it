{{< rawdetails title="singleton">}}

{{< rawdetails title="problem description">}}
We want to
1. Ensure a class has a single instance
2. Provide a global access point to that instance
{{< endrawdetails >}}


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


Notice that:
1. The constructor is private.
2. The instance field is private and **static**
{{< endrawdetails >}}


{{< endrawdetails >}}
