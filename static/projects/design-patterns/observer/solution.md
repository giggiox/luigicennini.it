{{< rawdetails title="observer">}}

## Problem
An object `Subject` has a state and one or more object(s) `Observer`s wants to know when the `Subject` state changes.

![](/projects/design-patterns/observer/observer1.png)

## Solution


{{< rawdetails title="1. polling">}}
**polling** means that `Observer` will constantly look at the state inside `Subject`. This solution is inefficient.
{{< endrawdetails >}}


{{< rawdetails title="2. use observer pattern">}}

This way, each `Observer` subscribes to a `Subject` and it's the `Subject` who has the task of informing all of it's `Observer`s when the state changes.

```java
import java.util.ArrayList;
import java.util.List;

// Subject we want to observe
class Subject { 
    public int state = 1;
    
    private List<Observer> observers = new ArrayList<>();
    
    public void addObserver (Observer observer) {
        observers.add(observer);
    }
    
    public void removeObserver (Observer observer) {
        observers.remove(observer);
    }

    public void notifyObservers () {
        for (Observer observer : this.observers) {
            observer.update();
        }
        // observers.forEach(Observer::update); // It's the same
    }
    
    public void someLogic () { // This logic can be even a setter for the state
        state = state * 2;
        notifyObservers(); // Be aware of this
    }

}

interface Observer  {
    void update ();
}

class ConcreteObserver1 implements Observer {
    
    private Subject sub;
    
    public ConcreteObserver1 (Subject sub) {
        this.sub = sub;
    }
    
    public void update () {
        System.out.println("Subject state is " + sub.state + " (from ConcreteObserver1)");
    }
}

class ConcreteObserver2 implements Observer {
    
    private Subject sub;
    
    public ConcreteObserver2 (Subject sub) {
        this.sub = sub;
    }
    
    public void update () {
        System.out.println("Subject state is " + sub.state + " (from ConcreteObserver2)");
    }
}

public class Client {
	public static void main (String[] args) {
		Subject s = new Subject();
		Observer observer1 = new ConcreteObserver1(s);
        Observer observer2 = new ConcreteObserver2(s);
		s.addObserver(observer1);
		s.addObserver(observer2);
		
		s.someLogic(); 
		// Will output: 
		// Subject state is 2 (from ConcreteSubscriber1)
		// Subject state is 2 (from ConcreteSubscriber2)
		
		s.someLogic(); 
        // Will output: 
		// Subject state is 4 (from ConcreteSubscriber1)
		// Subject state is 4 (from ConcreteSubscriber2)
	}
}
```

{{< endrawdetails >}}


## Notes


{{< rawdetails title="(example) class diagram">}}
The architecture described above is reflected in the class diagram below:
![](/projects/design-patterns/observer/observer.png)
{{< endrawdetails >}}

{{< rawdetails title="abstracting observer logic handling">}}
You can abstract the Observer logic handling inside the `Subject` in an abstract class `Subject` inherit from, like this

```java
abstract class AbstractSubject {
    private List<Observer> observers = new ArrayList<>();
    
    public void addObserver (Observer observer) {
        observers.add(observer);
    }
    
    public void removeObserver (Observer observer) {
        observers.remove(observer);
    }

    public void notifyObservers () {
        for (Observer observer : this.observers) {
            observer.update();
        }
        // observers.forEach(Observer::update); // It's the same
    }
}

class Subject extends AbstractSubject{
    public int state = 1;
    
    public void someLogic () { // This logic can be even a setter for the state
        state = state * 2;
        notifyObservers(); // Be aware of this
    }

}
```
{{< endrawdetails >}}



{{< endrawdetails >}}
