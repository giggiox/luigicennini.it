{{< rawdetails title="state">}}


{{< rawdetails title="probelem description">}}
We want to implement a finite state machine.

![](/projects/design-patterns/state/fsm.png)
{{< endrawdetails >}}



{{< rawdetails title="solution 1. use enum & if statement (bad)">}}
```java
Phone phone = new Phone();
		
JButton home = new JButton("Home");
home.addActionListener(e -> phone.onHomeButton());
				
JButton onAndOff = new JButton("on/off");
onAndOff.addActionListener(e -> phone.onPowerButton());
```

```java
enum State {
    OFF,
    LOCKED,
    READY
}


class Phone {
    private State state;
    
    public Phone () {
        this.state = State.OFF;
    }

    
    public void onPowerButton () {
        if (this.state == State.OFF) {
            this.state = State.LOCKED;
        } else if (this.state == State.LOCKED) {
            this.State = State.OFF;
        } else if (this.State == State.READY) {
            this.state = State.OFF;
        }
    }
    
    public void onHomeButton () {
        if (this.state == State.OFF) {
            this.state = State.LOCKED;
        } else if (this.state == State.LOCKED) {
            this.State = State.READY;
        } else if (this.State == State.READY) { }
    }
   
}
```



{{< endrawdetails >}}


{{< rawdetails title="solution 2. use state design pattern (good)">}}
We will interact with the phone using only the onHomeButton method and the onPowerButton method, and the internal state will change accordingly.
```java
Phone phone = new Phone();
		
JButton home = new JButton("Home");
home.addActionListener(e -> phone.getState().onHomeButton());
				
JButton onAndOff = new JButton("on/off");
onAndOff.addActionListener(e -> phone.getState().onPowerButton());
```



```java
class Phone {
    private State state;
    
    public Phone () {
        state = new OffState(this);
    }
    
    public State getState () {
        return this.state;
    }
    
    public void setState (State state) {
        this.state = state;
    }
}

abstract class State {
    protected Phone phone;
    
    public State (Phone phone) {
        this.phone = phone;
    }
    
    public abstract void onHomeButton ();
    public abstract void onPowerButton ();
    
}

class OffState extends State {
    public OffState (Phone phone) {
        super(phone);
    }
    
    @Override
    public void onHomeButton () {
        phone.setState(new LockedState(phone));
    }
    
    @Override
    public void onPowerButton () {
        phone.setState(new LockedState(phone));
    }
}

class LockedState extends State {
    public LockedState (Phone phone) {
        super(phone);
    }
    
    @Override
    public void onHomeButton () {
        phone.setState(new ReadyState(phone));
    }
    
    @Override
    public void onPowerButton () {
        phone.setState(new OffState(phone));
    }
}

class ReadyState extends State {
    public ReadyState (Phone phone) {
        super(phone);
    }
    
    @Override
    public void onHomeButton () { }
    
    @Override
    public void onPowerButton () {
        phone.setState(new OffState(phone));
    }
}
```
{{< endrawdetails >}}


{{< rawdetails title="notes">}}

{{< rawdetails title="class diagram">}}
{{< includeImage path="/projects/design-patterns/state/classdiagram.png" >}}
{{< endrawdetails >}}

{{< rawdetails title="state & strategy">}}
The state pattern can be considered as an extension of strategy.
The class diagram are pretty much the same.
They both use composition.

**Differences**: 
1. strategys are completely independent and unaware of each other, whereas states can be dependent.
2. strategy pattern is about having different implementation that accomplish the same thing.

{{< endrawdetails >}}



{{< endrawdetails >}}


{{< endrawdetails >}}
