# Classes and Objects - Part II

## Class methods and variables

* **Class methods** are methods we can call directly on the class itself, without having to instantiate any objects
* **Class variables** are variables for the entire class.
Class variables are created with `@@`.

## The `self` keyword

1. The `self` keyword can be used when calling a setter method from within a instance method definition.
Using `self` can disambiguate between initializing a local variable and calling a setter method.
This occurs because `self` from within the instance method definition references the calling object.
2. Also, it can be used to define a class method.
This is because `self` inside a class but outside an instance method refers to the class itself.
