class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

p Fruit.new("Apple").instance_variables
p Pizza.new("Cheese").instance_variables

# The `Pizza` class has a variable where the variable name starts with the `@` symbol.