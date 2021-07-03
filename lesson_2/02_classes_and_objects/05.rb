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

  def to_s
    name
  end

  private

  def assign_names(name)
    self.first_name, self.last_name = name.split
    self.last_name ||= ''
  end

end

bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"