class Vehicle
  attr_accessor :color, :speed
  attr_reader :year, :model
  @@number_of_vehicles = 0

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
    @@number_of_vehicles += 1
  end

  def speed_up(speed)
    self.speed += speed
    puts "You've sped up and the current speed is #{self.speed}."
  end

  def slow_down(speed)
    self.speed -= speed
    puts "You've slowed down and the current speed is #{self.speed}."
  end

  def age
    puts "This car is #{years_elapsed} years old."
  end

  def to_s
    "This is a #{year} #{model} in #{color}."
  end

  def self.number_of_vehicles
    puts "This program has created #{@@number_of_vehicles} vehicles"
  end

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon"
  end

  private

  def years_elapsed
    Time.now.year - year
  end

end

module Towable
  def can_tow?(pounds)
    pounds < 2000 ? true : false
  end
end

class MyCar < Vehicle
  NUMBER_OF_DOORS = 4
end

class MyTruck < Vehicle
  include Towable

  NUMBER_OF_DOORS = 2
end

porsche = MyCar.new(2010, "Black", "Cayenne")
porsche.age