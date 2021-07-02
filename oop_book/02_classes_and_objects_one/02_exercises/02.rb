class MyCar
  attr_accessor :color, :speed
  attr_reader :year

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def speed_up(speed)
    self.speed += speed
    puts "You've sped up and the current speed is #{self.speed}."
  end

  def slow_down(speed)
    self.speed -= speed
    puts "You've slowed down and the current speed is #{self.speed}."
  end

  def shut_off
    self.speed = 0
    puts "You've shut off the car."
  end
end

porsche = MyCar.new(2021, "Black", "Cayenne")

porsche.color = "yellow"
puts porsche.color
puts porsche.year