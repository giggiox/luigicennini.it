{{< rawdetails title="iterator">}}

{{< rawdetails title="problem description">}}
Given a component containing an aggregate of elements, we want a way to iterate over it without knowing the underlying data structure  (array, hashmap, graph, tree...).
```java
class Social1 {
    private List<String> emails = new ArrayList<>();
    
    public Social1 () { }
    
    public void addUser (String email) {
        this.emails.add(email);
    }
    
    public List getEmails () {
        return emails;
    }
}
```
The problem of this code is that  if i change the implementation of `emails` from `List` to `HashSet` clients will break. I can change the type to be a `Collection` but again, if i change the implementation to be an array, clients will break again.

{{< endrawdetails >}}


{{< rawdetails title="solution using iterator pattern">}}
Iterator pattern gives a way of accessing aggregate elements in a *sequential* way without exposing underlying representation.

It exposes only 2 interface method: `hasNext` and `getNext`.

```java
Social1 s1 = new Social1();
s1.addUser("luigi");
s1.addUser("cennini");
Social1Iterator s1it = s1.createIterator();
	    
while (s1it.hasNext()) {
	String user = s1it.getNext();
	System.out.println(user);
}
```

```java
import java.util.ArrayList;
import java.util.List;

class Social1 {
    private List<String> emails = new ArrayList<>();
    
    public Social1 () { }
    
    public void addUser (String email) {
        this.emails.add(email);
    }
    
    public Social1Iterator createIterator () {
        return new Social1Iterator(emails);
    }
}

class Social1Iterator {
    private List<String> emails;
    private int currentPosition = 0;
    
    public Social1Iterator (List<String> emails) {
        this.emails = emails;
    }
    
    public boolean hasNext () {
        return currentPosition < emails.size();
    }
    
    public String getNext () {
        if (!hasNext()) {
            return null;
        }
        String email = emails.get(currentPosition);
        currentPosition ++;
        return email;
    }
    
}
```
{{< endrawdetails >}}





{{< rawdetails title="notes">}}

{{< rawdetails title="(example) class diagram">}}
{{< includeImage path="/projects/design-patterns/iterator/iterator.png" >}}
{{< endrawdetails >}}


{{< rawdetails title="Another example, tree iterator">}}
Having a Tree like structure, i want an iterator to easily iterate over the structure in pre order and in order traversal ways.
```java
Node root = new Node(10);   //                   10
root.left = new Node(20);   //              20        30
root.right = new Node(30);  //          50     80
root.left.left = new Node(50);
root.left.right = new Node(80);
		
		
System.out.println("In order traversal: ");
TreeIterator ti1 = root.createPreOrderIterator();
while (ti1.hasNext()) {
	Node current = ti1.getNext();
	System.out.println(current.val);
}
//prints: 10 20 50 80 30
		
System.out.println("Post order traversal: ");
TreeIterator ti2 = root.createInOrderIterator();
while (ti2.hasNext()) {
	Node current = ti2.getNext();
	System.out.println(current.val);
}
//prints: 50 20 80 10 30
```


```java
import java.util.Stack;

class Node {
    public int val;
    public Node left = null, right = null;
    
    public Node (int val){
        this.val = val;
    }
    
    
    public TreeIterator createPreOrderIterator () {
        return new PreOrderIterator(this);
    }
    
    public TreeIterator createInOrderIterator () {
        return new InOrderOrderIterator(this);
    }
}


interface TreeIterator {
    boolean hasNext ();
    Node getNext ();
}

class PreOrderIterator implements TreeIterator{
    
    private Stack<Node> stack = new Stack<>();
    
    public PreOrderIterator(Node root) {
        stack.push(root);
    }
    
    @Override
    public boolean hasNext() {
        return !stack.isEmpty();
    }
    
    @Override
    public Node getNext() {
        if (!hasNext()) {
            return null;
        }
        Node current = stack.pop();
        if (current.right != null) {
            stack.push(current.right);
        }
        if (current.left != null) {
            stack.push(current.left);
        }
        return current;
    }
    
}


class InOrderOrderIterator implements TreeIterator{
    
    private Stack<Node> stack = new Stack<>();
    private Node current;

    
    public InOrderOrderIterator(Node root) {
        this.current = root;
    }
    
    @Override
    public boolean hasNext() {
        return !stack.isEmpty() || current != null;
    }
    
    @Override
    public Node getNext() {
        while (current != null) {
            stack.push(current);
            current = current.left;
        }
        if (!stack.isEmpty()) {
            Node node = stack.pop();
            current = node.right;
            return node;
        }
        return null;
    }
    
}
```
{{< endrawdetails >}}

{{< rawdetails title="(official) class diagram">}}
{{< includeImage path="/projects/design-patterns/iterator/iterator1.png" >}}
{{< endrawdetails >}}


{{< endrawdetails >}}




{{< endrawdetails >}}
