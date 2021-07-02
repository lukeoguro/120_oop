class MyCar
  attr_accessor :year, :color, :model

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon"
  end

  def to_s
    "This is a #{year} #{model} in #{color}."
  end
end

porsche = MyCar.new(2021, "Black", "Cayenne")

puts porsche