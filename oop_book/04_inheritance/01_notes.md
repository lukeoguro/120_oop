# Inheritance

## The `super` keyword

The `super` keyword can be used to call methods earlier in the method lookup path.
It searches for a method of the same name earlier in the method lookup path and invokes it.

## Modules

There are two main ways that Ruby implements inheritance.

1. Class inheritance is the traditional way.
2. The other form is interface inheritance. This is where mixins come into play, where the class doesn't inherit from another type, but instead inherits the interface provided by the mixin module.

Whether to use class or interface inheritance can be determined by the relationship.
If there is a 'is-a' relationship, class inheritance probably makes more sense.
If there is a 'has-a' relationship, interface makes more sense.

## More modules

Modules can be used for **namespacing**.
This is when similar classes are organized under a module.

```ruby
module Mammal
  class Dog
    def speak(sound)
      p "#{sound}"
    end
  end

  class Cat
    def say_name(name)
      p "#{name}"
    end
  end
end

buddy = Mammal::Dog.new
kitty = Mammal::Cat.new
buddy.speak('Arf!')           # => "Arf!"
kitty.say_name('kitty')       # => "kitty"
```

Another case is when modules are used as a container for methods.
They are called module methods.

```ruby
module Mammal
  ...

  def self.some_out_of_place_method(num)
    num ** 2
  end
end

value = Mammal.some_out_of_place_method(4)
```

## Private, Protected, and Public

**Method Access Control** has to do with restricting access to certain methods defined in a class.
This is implemented by using the `public`, `private` and `protected` access modifiers.

A **public method** is a method that is available to anyone who knows either the class name or the object's name.
On the other hand, a **private method** can only be accessed by other methods in the class.

```ruby
def public_disclosure
  "#{self.name} in human years is #{human_years}"
end
```

Here, `human_years` is a private method.
Forgetting the current caveat, we cannot call `self.human_years` because this is equivalent to `instance.human_years`, and the instance cannot access the method.

Lastly, **private methods** lie between public and private methods.
From inside the class, protected methods act like public methods.
From outside the class, protected methods act like private methods.

## Phrases

```ruby
class Animal
  def speak
    "Hello!"
  end
end

class GoodDog < Animal
  attr_accessor :name

  def initialize(n)
    self.name = n
  end

  def speak
    "#{self.name} says arf!"
  end
end

class Cat < Animal
end

sparky = GoodDog.new("Sparky")
paws = Cat.new

puts sparky.speak           # => Sparky says arf!
puts paws.speak             # => Hello!
```

In the `GoodDog` class, we're overriding the `speak` method in the `Animal` class because Ruby checks the object's class first for the method before it looks in the superclass.

```ruby
class Animal
  def speak
    "Hello!"
  end
end

class GoodDog < Animal
  def speak
    super + " from GoodDog class"
  end
end

sparky = GoodDog.new
sparky.speak        # => "Hello! from GoodDog class"
```

In the above example, we've created a simple `Animal` class with a `speak` instance method.
We then created `GoodDog` which subclasses `Animal` also with a `speak` instance method to override the inherited version.
However, in the subclass' speak method we use `super` to invoke the `speak` method from the superclass, `Animal`, and then we extend the functionality by appending some text to the return value.
