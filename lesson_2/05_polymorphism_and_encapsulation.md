# Polymorphism and encapsulation

## Polymorphism

Polymorphism refers to the ability of different object types to respond in different ways to the same method invocation.

Implementation:

* Polymorphism through inheritance
  * Instead of providing class-specific behavior, inheritance is used to acquire the behavior of the superclass
  * Often times, a method is defined in the class to **override** a method inherited by a superclass.
  This is considered as polymorphism through inheritance as well
* Polymorphism through duck typing
  * **Duck typing** occurs when two unrelated objects both respond to the same method name
  * Just because two different type objects have the same method name, doesn't mean you have polymorphism.
  Polymorphic methods are intentionally designed to be polymorphic

## Encapsulation

Encapsulation lets us hide the internal representation of an object from the outside and only expose the methods and properties that users of the object needs.

```ruby { .line-numbers }
class Dog
  attr_reader :nickname

  def initialize(n)
    @nickname = n
  end

  def change_nickname(n)
    self.nickname = n
  end

  def greeting
    "#{nickname.capitalize} says Woof Woof!"
  end

  private

  attr_writer :nickname
end

dog = Dog.new("rex")
dog.change_nickname("barny") # changed nickname to "barny"
puts dog.greeting # Displays: Barny says Woof Woof!
```

In the code above, the `nickname` setter method is invoked with `self` prepended; this is necessary when calling private setter methods because otherwise, Ruby would assume a local variable is being initialized.

This is an exception and this does not mean that `dog.nickname = n` would work.
This also does not mean that the private `nickname` setter method can be invoked on another object.
