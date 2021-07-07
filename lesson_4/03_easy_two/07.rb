class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

Cat.new("Persian")
Cat.new("Persian")
Cat.new("Persian")
p Cat.cats_count

# The `@@cats_count` variable keeps track of how many `Cat` objects were created.