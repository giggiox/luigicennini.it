{{< rawdetails title="adapter">}}

{{< rawdetails title="problem description">}}

We want to allow objects with incompatible interfaces to work together.

Suppose you have an app that displays menus using XML data, like this.
```java
interface IApp {
	void displayMenus (XmlData xmlData);
}

class App implements IApp {
	@Override
	public void displayMenus (XmlData xmlData) {
		// Displays menu using XML data
	}
}
```

One day, you want to enhance how you display menus, and you find the perfect UI library.
The problem is that this library uses JsonData to display menus!

```java
class FancyUIService {
	public void displayMenus (JsonData jsonData) {
		// Make use of the JsonData to fetch menus
	}
}
```


So how can we make the 2 components work together?

{{< endrawdetails >}}

{{< rawdetails title="solution using adapter design pattern">}}
```java
XmlData xmlDataToDisplay = new XmlData();

IApp app = new App();
app.displayMenus(xmlDataToDisplay); // Show menu using old UI

IApp adapter = new FancyUIServiceAdapter();
adapter.displayMenus(xmlDataToDisplay); // Show menu using new fancy UI
```


```java

class FancyUIServiceAdapter 
	extends FancyUIService 
	implements IApp{
	
	@Override
	public void displayMenus (XmlData xmlData) {
		super.displayMenus(convertXmlToJson(xmlData));
	}
	
	private JsonData convertXmlToJson (XmlData xmlData) {
		// Convert XmlData to JsonData and return it
	}
}
```

Note that if `FancyUIService` is final you can use composition instead of hineritance and do like this:
```java

class FancyUIServiceAdapter implements IApp{
	
	private final FancyUIService fancyUIService;
	
	public FancyUIServiceAdapter () {
		this.fancyUIService = new FancyUIService();
	}
	
	@Override
	public void displayMenus (XmlData xmlData) {
		super.displayMenus(convertXmlToJson(xmlData));
	}
	
	private JsonData convertXmlToJson (XmlData xmlData) {
		// Convert XmlData to JsonData and return it
	}
}
```
{{< endrawdetails >}}


{{< rawdetails title="notes">}}


{{< rawdetails title="example class diagram">}}


<pre class="graphviz">
digraph {
    bgcolor="#f8f9fA"
    node [
        fontname="Helvetica,Arial,sans-serif"
        shape=record
        style=filled
        fillcolor=gray95
    ]

    Client [label="{
            Client    
        }",
        pos="-3,1!"
    ]

    Target [label="{
        «interface»\n
            Target
            |
            method(data)\l
        }",
        pos="0,1!"
    ];
    
    ConcreteTarget [
        label="{
            ConcreteTarget
            |
            method(data)\l
        }",
        pos="-1,-1!"
    ]
    
    Adapter [
        label="{
            Adapter
            |
            method(data)\l
        }",
        pos="2,-1!"
    ]
    
    Service [
        label="{
            Service
            |
            serviceMethod(specialData)\l
        }",
        pos="3,1!"
    ]
    
    Client -> Target;
    ConcreteTarget -> Target [style=dashed, arrowhead="empty"];
    Adapter -> Target [style=dashed, arrowhead="empty"];
    Adapter -> Service [arrowhead="empty"];


}
</pre>


<!-- {{< includeImage path="/projects/design-patterns/adapter/adapter.png" >}} -->

{{< endrawdetails >}}

{{< rawdetails title="adapter & decorator">}}
The main objective of the Adapter pattern is to adapt an **interface** to another, where this interface is expected by the client.
In the example you have an interface IApp which is obsolete, the objective is to adapt FancyUIService to resemble an implementation of IApp.
{{< endrawdetails >}}

{{< endrawdetails >}}

{{< endrawdetails >}}

