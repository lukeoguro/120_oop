module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

small_car = Car.new
small_car.go_fast

# We call `self.class` in the method.
# The `self` prefix refers to a Car object.
# The `class` method returns the class itself.
# Since this is interpolated in the String, calling `to_s` is not necessary.
