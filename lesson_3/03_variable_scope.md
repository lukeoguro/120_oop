# Variable scope

## Instance variable scope

* Scoped at the object level to track individual object state, and do not cross over between objects
* Accessible within a method even if it was initialized in another method
* Does not have to be passed in to be accessible within a method
* Referencing an uninitialized instance variable will return `nil`

## Class variable scope

* Class variables are scoped at the class level
* All objects of the same class share one copy of the class variable. This remains true even if reassigned
* The caveat is that the same copy is shared even in an inheritance relationship. This can result in surprising behavior like below

```ruby { .line-numbers }
class Vehicle
  @@wheels = 4

  def self.wheels
    @@wheels
  end
end

p Vehicle.wheels                              # => 4

class Motorcycle < Vehicle
  @@wheels = 2
end

p Motorcycle.wheels                           # => 2
p Vehicle.wheels                              # => 2  Yikes!
```

## Constant variable scope

* Constants have lexical variable scope. Lexical scope means that the scope of the object remains limited to where it's defined in the code
* Constants of different classes can be referenced with `::`, which is the namespace resolution operator
* A constant initialized in a super-class is inherited by the sub-class, and can be accessed by both class and instance methods.
In this case, `::` does not need to be used.
But, lexical scope still applies.
The example below outputs `4` on line 17, because the method was defined in the `Car` class.
A solution would be to change line 5 to `self.class::WHEELS`.

```ruby { .line-numbers }
class Car
  WHEELS = 4

  def wheels
    WHEELS
  end
end

class Motorcycle < Car
  WHEELS = 2
end

civic = Car.new
puts civic.wheels # => 4

bullet = Motorcycle.new
puts bullet.wheels # => 4, when you expect the out to be 2
```

* Another caveat is when constants are referenced in a module.
If the constant wasn't initialized in the module and `==` wasn't used, an error is raised.
An example is below:

```ruby { .line-numbers }
module Maintenance
  def change_tires
    "Changing #{WHEELS} tires."
  end
end

class Vehicle
  WHEELS = 4
end

class Car < Vehicle
  include Maintenance
end

a_car = Car.new
a_car.change_tires # => NameError: uninitialized constant Maintenance::WHEELS
```

* There are 3 separate searches that can occur: lexical, inheritance, and top-level.
  * Constant resolution will look at the lexical scope first.
This involves the method and the class or module that contains the method.
  * Then, it goes to the inheritance chain by calling the `ancestors` method.
  If the method is in a module, it doesn't search the class because the class is not in the module's inheritance chain
  * Lastly, it looks at the top-level, which are global constants.
