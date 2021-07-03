class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    assign_names(name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(name)
    assign_names(name)
  end

  private

  def assign_names(name)
    self.first_name, self.last_name = name.split
    self.last_name ||= ''
  end

end

bob = Person.new('Robert')

puts bob.name                  # => 'Robert'
puts bob.first_name            # => 'Robert'
puts bob.last_name             # => ''
bob.last_name = 'Smith'
puts bob.name                  # => 'Robert Smith'

bob.name = "John Adams"
puts bob.first_name            # => 'John'
puts bob.last_name             # => 'Adams'