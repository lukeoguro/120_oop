# The Object Model

## What is Object Oriented Programming?

**Object Oriented Programming** is a programming paradigm that allows programmers to create containers for data that could be changed or manipulated without affecting the entire program.
This way, programmers can deal with the growing complexity of large software programs and not have a massive blob of dependency.

OOP also allows programmers to think on a new level of abstraction.
Objects are real-world nouns and method names describe the behavior the programmer is trying to represent.

## Terminology

* **Encapsulation** is hiding pieces of functionality and making it unavailable to the rest of the code base.
This is a form of data protection, so data cannot be manipulated without obvious intention.
This is done by creating objects and defining methods to interact with these objects.
* **Polymorphism** is the ability for different types of data to respond to the same method.
This occurs when different object types execute compatible results, regardless of implementation.
In other words, objects of different types respond to the same method invocation.
* **Inheritance** occurs when a class (**subclass**) inherits the behavior of another class (**superclass**).

## Phrases

```ruby
class GoodDog
end

sparky = GoodDog.new
```

* We created an instance of our `GoodDog` class and stored it in the variable `sparky`.
We now have an object.
* We say that `sparky` is an object or instance of class `GoodDog`.
* We can also say that we've instantiated an object called `sparky` from the class `GoodDog`.
* We create an object by defining a class and instantiating it by using the `new` method to create an instance, also known as an object.

```ruby
module Speak
  def speak(sound)
    puts sound
  end
end

class GoodDog
  include Speak
end

class HumanBeing
  include Speak
end

sparky = GoodDog.new
sparky.speak("Arf!")        # => Arf!
bob = HumanBeing.new
bob.speak("Hello!")         # => Hello!
```

* A module must be mixed in with a class using the `include` method invocation. This is called a **mixin**.
* After mixing in a module, the behaviors declared in that module are available to the class and its objects.
* A module allows us to group reusable code into one place.
We use modules in our classes by using the `include` method invocation, followed by the module name.
