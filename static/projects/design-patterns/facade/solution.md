{{< rawdetails title="facade">}}

{{< rawdetails title="problem description">}}

You have an object that has to interact with a broad set of objects that belong to a sophisticated library.
To do that you would normally initilize all the objects, execute methods and so on.

The result is that the business logic will be tightly coupled with the implementation of 3rd-party classes, making it hard to mantain.

{{< includeImage path="/projects/design-patterns/facade/facade.png" >}}

{{< endrawdetails >}}



{{< rawdetails title="using facade pattern">}}
We use facade pattern to hide the complexity of the system.

```java
ComputerFacade computer = new ComputerFacade();
computer.start();
```


```java
interface CPU {
  void freeze ();
  void jump (int position);
  void execute ();
}

interface HardDrive {
  String read(int lba, int size);
}

interface Memory {
  void load(int position, String data);
}

class ComputerFacade {
	private CPU cpu;
	private Memory memory;
	private HardDrive hardDrive;

	public void start () {
		cpu.freeze();
		memory.load(kBootAddress, hardDrive.read(kBootSector, kSectorSize));
		cpu.jump(kBootAddress);
		cpu.execute();
	}
}
```
{{< endrawdetails >}}



{{< rawdetails title="notes">}}

{{< rawdetails title="facade & decorator">}}
Facade wraps a whole system while Decorator wraps only a component of the system.
{{< endrawdetails >}}

{{< endrawdetails >}}


{{< endrawdetails >}}
