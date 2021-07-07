class Cube
  attr_reader :volume
  def initialize(volume)
    @volume = volume
  end
end

p Cube.new(5000).volume