module Walk
  def walk
    puts "Walk!"
  end
end

class GoodDog
  include Walk
end

kiki = GoodDog.new
kiki.walk
