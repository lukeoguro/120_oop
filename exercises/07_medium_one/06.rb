class GuessingGame
  def initialize
    @num_of_guesses = 7
    @answer = rand(1..100)
  end

  def play
    loop do
      puts "You have #{@num_of_guesses} guesses remaining."
      guess = nil

      loop do
        print "Enter a number between 1 and 100: "
        input = gets.chomp
        if input.to_i.to_s == input && (1..100).include?(input.to_i)
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

game = GuessingGame.new
game.play
