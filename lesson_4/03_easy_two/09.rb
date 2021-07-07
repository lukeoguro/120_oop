class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end

  def play
    "Override the method inherited from the Game class"
  end
end

p Bingo.new.play