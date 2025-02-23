---
title: "Why Java Strings are special"
date: 2025-02-14T19:53:33+05:30
draft: false
author: "Luigi"
tags:
  - Rich content
  - Sample
  - example
description: ""
toc: true
mathjax: true
---

{{< rawhtml >}} 
<script>
MathJax = {
	tex: {
		inlineMath: [["$", "$"]]
	}
};
</script>

<style>

body img{
    filter: invert(100%);
    mix-blend-mode: difference;
    background-color: #18191A; /* Questo diventa il nuovo "bianco" */
}
.navbar-brand img{
	filter: none;
	mix-blend-mode: normal;
}

</style>


    
{{< /rawhtml >}}

The other day, something struck me:

> When you write `String a = "hello";` in Java, what exactly is "hello"?

In Java, `char` is a primitive type, but a string (the quoted text) is not. 
Instead, Java provides a String object. Yet when you write `String a = "hello";` you're not explicitly using the `new` keyword and also you are not using any of the primitive types.
 
So, are we really instantiating a String object, or is something else happening?

## Object instantiation in Java
Let’s review how object instantiation typically works. Consider the following example:
```java
class Foo { }
...
Foo foo = new Foo();
```
In this case, `foo` is a reference to a new `Foo` object allocated in the heap memory.
Visually:
{{< includeImage path="/blog/java-strings/1.png">}}


However, this is **not** what happens when you write:
```java
String a1 = "hello";
```
We can observe two things:
1. `a1` is not created via an explicit object instantiation (there's no `new` keyword)
2. `a1` must holds a reference that points to a `String` object, like in the `Foo` object case.

So what happens under the hood is that when the program is being compiled, the compiler recognizes `"hello"` as a string and does the following:
```java
if SCP already has "hello":
	return that
else:
	create "hello" in SCP
	return that
```

SCP (String Constant Pool) is a special area of the heap used for this purpose. 

Visually:
{{< includeImage path="/blog/java-strings/2.png">}}

---
You can look yourself the HotSpot JVM code [here](https://github.com/openjdk/jdk/blob/master/src/hotspot/share/classfile/stringTable.cpp).
When parsing a string, the following function is called:

```cpp
oop StringTable::intern(const StringWrapper& name, TRAPS) {
  unsigned int hash = hash_wrapped_string(name);
  oop found_string = lookup_shared(name, hash);
  if (found_string != nullptr) {
    return found_string;
  }

  ...

  return do_intern(name, hash, THREAD);
}
```

We can see that
1. It calculates the key of the lookup table (SCP) i.e the hash of the String
2. Looks for the String in the lookup table (SCP), if it is present (`found_string != nullptr`) then it returns that string
3. If the string is not present in the lookup table (SCP), it creates it using the `do_intern` method.





---

The provided SCP algorithm above gives us a way to know what happens if we run this script:
```java
String a1 = "hello";
String a2 = "hello";
```

That is, both `a1` and `a2` will holds the same reference.

{{< includeImage path="/blog/java-strings/3.png">}}

This is the reason we can test if SCP created strings are the same using the `==` operator:
```java
String a1 = "hello";
String a2 = "hello";
System.out.pritln(a1 == a2); // True, but in general don't use == to test String equality
```


## Another way to use Java String
In Java you have the option to create String in the heap like every other object:
```java
String a4 = new String("hello");
```
What happens this time is that the compiler recognizes first there is a string `"hello"` then it also sees that it is surrounded by an object instantiation, for this reason it will pass the string to the String object constructor.
The result is that this will create a `String` object in the heap, like with `Foo` object.

You can put the String object in the SCP using the `String` `intern()` method.
```java
String a4 = new String("hello");
String a5 = new String("hello").intern();
String a6 = "hello";
System.out.println(a4 == a5); // False
System.out.println(a5 == a6); // True, because a5 is in SCP
```

## Test your understanding
Given the explanation above, you might be able to tell what the output  of the following script is going to be:
```java
String a1 = "hello";
String a2 = "hello";
String a3 = "other";
Foo foo = new Foo();
String f4 = new String("hello");

System.out.println(a1 == a2); // True
System.out.println(a2 == a3); // False
System.out.println(a4 == a1); // False
System.out.println(foo == a1); // False
```
Visually:
{{< includeImage path="/blog/java-strings/5.png">}}

This demonstrates that the `==` operator checks for reference equality, not content equality.
To properly compare the content of String(s), you should use the `.equals()` method, like so:
```java
System.out.println(a1.equals(a4)); // True
```


Luigi