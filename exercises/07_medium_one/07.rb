class GuessingGame
  def initialize(min, max)
    @min = min
    @max = max
    @num_of_guesses = Math.log2(@max - @min).to_i + 1
    @answer = rand(@min..@max)
  end

  def play
    loop do
      puts "You have #{@num_of_guesses} guesses remaining."
      guess = nil

      loop do
        print "Enter a number between #{@min} and #{@max}: "
        input = gets.chomp
        if input.to_i.to_s == input && (@min..@max).include?(input.to_i)
          guess = input.to_i
          break
        end
        print "Invalid guess. "
      end

      if guess == @answer
        puts "That's the number!"
        break
      elsif guess > @answer
        puts "Your guess is too high."
      else
        puts "Your guess is too low."
      end

      @num_of_guesses -= 1

      if @num_of_guesses == 0
        puts "You have no more guesses. You lost!"
        break
      end
    end
  end
end

game = GuessingGame.new(501, 1500)
game.play
