class Cat
  attr_accessor :name, :color
  DEFAULT_COLOR = "purple"

  def initialize(name)
    @name = name
    @color = DEFAULT_COLOR
  end

  def greet
    puts "Hello! My name is #{name} and I'm a #{color} cat!"
  end
end

kitty = Cat.new('Sophie')
kitty.greet
