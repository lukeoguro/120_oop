# Classes and Objects - Part I

## States and behaviors

* States track attributes for individual objects.
This is done with instance variables.
* Behaviors are what objects are capable of doing.
All objects of the same class contain identical behaviors, which is done with instance methods.
Instance methods defined in a class are available to all objects of that class.

## Phrases

```ruby
sparky = GoodDog.new("Sparky")
```

Here, the string `Sparky` is being passed from the `new` method through to the `initialize` method, and is assigned to the local variable `name`.
Within the constructor (i.e., the `initialize` method), we then set the instance variable `@name` to `name`, which results in assigning the string `Sparky` to the `@name` instance variable.

```ruby
class GoodDog
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "#{name} says arf!"
  end
end
```

The `attr_accessor` method takes a symbol as an argument, which it uses to create the method name for the getter and setter methods.
