{{< rawdetails title="publish-subscriber">}}


{{< rawdetails title="problem description">}}

The problem is the same as the observer pattern: we have a Subject we want to observe for it's updates.

This time though there is a twist: in this case a message is not broadcasted to all observers but a subscriber can subscribe to different topics he is interested into.

{{< includeImage path="/projects/design-patterns/pubsub/pubsub1.PNG" >}}

{{< endrawdetails >}}



{{< rawdetails title="solution using publish-subscriber pattern">}}

```java
MessageBroker broker = new MessageBroker();

// Subscribers si iscrivono a topic specifici
Subscriber sub1 = new ConcreteSubscriber1();
Subscriber sub2 = new ConcreteSubscriber2();

broker.subscribe("news", sub1);
broker.subscribe("news", sub2);
broker.subscribe("updates", sub2); // sub2 also subscribes to a different topic

Publisher publisher = new Publisher(broker);
publisher.sendMessage("news", "Breaking News!");
// ConcreteSubscriber1 received: Breaking News!
// ConcreteSubscriber2 received: Breaking News!
        
publisher.sendMessage("updates", "System update available.");
// ConcreteSubscriber2 received: System update available.
```



```java
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class Publisher {
    private MessageBroker broker;

    public Publisher(MessageBroker broker) {
        this.broker = broker;
    }

    public void sendMessage(String topic, String message) {
        broker.publish(topic, message);
    }
}

class MessageBroker {
    private Map<String, List<Subscriber>> subscribers = new HashMap<>();

    public void subscribe(String topic, Subscriber subscriber) {
        this.subscribers.putIfAbsent(topic, new ArrayList<>());
        this.subscribers.get(topic).add(subscriber);
    }

    public void publish(String topic, String message) {
        if (this.subscribers.containsKey(topic)) {
            for (Subscriber subscriber : subscribers.get(topic)) {
                subscriber.receive(message);
            }
        }
    }
}


interface Subscriber {
    void receive(String message);
}


class ConcreteSubscriber1 implements Subscriber {
    public void receive(String message) {
        System.out.println("ConcreteSubscriber1 received: " + message);
    }
}

class ConcreteSubscriber2 implements Subscriber {
    public void receive(String message) {
        System.out.println("ConcreteSubscriber2 received: " + message);
    }
}
```


{{< endrawdetails >}}


{{< rawdetails title="notes">}}

{{< rawdetails title="(example) class diagram">}}
The architecture described above is reflected in the class diagram below:

<pre class="graphviz">
digraph {
    bgcolor="#f8f9fa"
    node [
        fontname="Helvetica,Arial,sans-serif"
        shape=record
        style=filled
        fillcolor=gray95
    ]

    Publisher [label="{
        Publisher\n
        |
        -broker: MessageBroker\l
        |
        sendMessage(String topic, String message)\l
            
        }",
        pos="-8,0!"
    ];
    
    MessageBroker [ 
        label="{
            MessageBroker\n
            |
            -subscribers: Map﹤String, List﹤Subscriber﹥﹥\l
            |
            subscribe(String topic, Subscriber)\l
            publish(String topic, String message)\l
        }",
        pos="-3,0!"
    ]
    
    
    Subscriber [ 
        label="{
            «interface»\n
            Subscriber
            |
            receive(message)\l
        }",
        pos="4,0!"
    ]
    
    ConcreteSubscriber1 [ 
        label="{
            ConcreteSubscriber1
            |
            receive(message)\l
        }",
        pos="3,-2!"
    ]
    
    ConcreteSubscriber2 [ 
        label="{
            ConcreteSubscriber2
            |
            receive(message)\l
        }",
        pos="6,-2!"
    ]
    
    
    ConcreteSubscriber1 -> Subscriber [style=dashed, arrowhead="empty"];
    ConcreteSubscriber2 -> Subscriber [style=dashed, arrowhead="empty"];
    MessageBroker -> Subscriber [arrowtail=odiamond, dir=both, arrowhead="none"];
    Publisher -> MessageBroker [style=dashed, arrowhead="vee"];
}
</pre>
<!-- {{< includeImage path="/projects/design-patterns/pubsub/pubsub.png" >}} -->

{{< endrawdetails >}}

{{< endrawdetails >}}


{{< endrawdetails >}}
