{{< rawdetails title="static factory method">}}

{{< rawdetails title="problem description">}}
Suppose you have a complex object to build, you can do that in many ways.
{{< endrawdetails >}}



{{< rawdetails title="solution 1. (bad) use constructor overload">}}
```java
class TimeSpan {

	private int seconds;
	private int minutes;
	private int hours;
	
	private TimeSpan (int seconds, int minutes, int hours) {
		this.seconds = seconds;
		this.minutes = minutes;
		this.hours = hours;
	}
}
```

In the example above, you will instantiate the object `TipeStamp` with `new TipeStamp(0,10,0)`. But if you only read this without looking at the implementation of `TipeStamp` you can't understand how the object is instantiated.

{{< endrawdetails >}}


{{< rawdetails title="solution 2. using static factory method pattern">}}

Using static factory method pattern, instead of typing `new MyType()` you will write  `MyType.create()`.

```java
class TimeSpan {

	private int seconds;
	private int minutes;
	
	private TimeSpan (int seconds, int minutes) {
		this.seconds = seconds;
		this.minutes = minutes;
	}
	
	public static TimeSpan ofSeconds (int seconds) {
		return new TimeSpan(seconds, 0);
	}
	
	public static TimeSpan ofMinutes (int minutes) {
		return new TimeSpan(0, minutes);
	}
}
```

So if you want to add another field, say hours, clients won't break because they will still call the static method correctly, you are the one that has to change the `TimeSpan` implementation. 

```java
class TimeSpan {

	private int seconds;
	private int minutes;
	private int hours;
	
	private TimeSpan (int seconds, int minutes, int hours) {
		this.seconds = seconds;
		this.minutes = minutes;
		this.hours = hours;
	}
	
	public static TimeSpan ofSeconds (int seconds) {
		return new TimeSpan(seconds, 0, 0);
	}
	
	public static TimeSpan ofMinutes (int minutes) {
		return new TimeSpan(0, minutes, 0);
	}
	
	public static TimeSpan ofHours (int hours) {
		return new TimeSpan(0, 0, hours);
	}
	
}
```

Notice that:
1. The constructor is kept **private**.
{{< endrawdetails >}}





{{< endrawdetails >}}
