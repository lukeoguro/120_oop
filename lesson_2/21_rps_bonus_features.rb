module Displayable
  VALID_YES_NO = ['y', 'yes', 'n', 'no']

  def prompt(message)
    message.each_line { |line| puts("=> #{line}") }
  end

  def clear_screen
    system('clear') || system('cls')
  end
end

class Move
  attr_reader :name, :beats

  @@subclasses = []

  def self.inherited(subclass)
    @@subclasses << subclass
  end

  def self.all
    @@subclasses
  end

  def to_s
    name
  end

  def beats?(other_move)
    beats.keys.include?(other_move.class)
  end

  def win_verb(other_move)
    beats[other_move.class]
  end
end

class Rock < Move
  def initialize
    @name = 'Rock'
    @beats = {
      Scissors => 'crushes',
      Lizard => 'crushes'
    }
  end
end

class Paper < Move
  def initialize
    @name = 'Paper'
    @beats = {
      Rock => 'covers',
      Spock => 'disproves'
    }
  end
end

class Scissors < Move
  def initialize
    @name = 'Scissors'
    @beats = {
      Paper => 'cuts',
      Lizard => 'decapitates'
    }
  end
end

class Lizard < Move
  def initialize
    @name = 'Lizard'
    @beats = {
      Spock => 'poisons',
      Paper => 'eats'
    }
  end
end

class Spock < Move
  def initialize
    @name = 'Spock'
    @beats = {
      Scissors => 'smashes',
      Rock => 'vaporizes'
    }
  end
end

class Player
  include Displayable
  attr_accessor :move
  attr_reader :name

  def to_s
    name
  end
end

class Human < Player
  attr_writer :name

  INPUT_TO_MOVE = {
    ['r', 'rock'] => Rock,
    ['p', 'paper'] => Paper,
    ['s', 'scissors'] => Scissors,
    ['l', 'lizard'] => Lizard,
    ['k', 'spock'] => Spock
  }

  def set_name
    input = nil
    loop do
      prompt("Welcome! What's your name?")
      input = gets.chomp.strip.capitalize
      break unless input.empty?
      prompt("Please enter a valid name.")
    end
    self.name = input
  end

  def choose
    input = nil
    loop do
      prompt("Choose one: (r)ock, (p)aper, (s)cissors, spoc(k), (l)izard")
      input = gets.chomp.strip.downcase
      break if INPUT_TO_MOVE.keys.flatten.include?(input)
      prompt("Please enter a valid move.")
    end
    self.move = convert_input_to_move(input)
  end

  private

  def convert_input_to_move(input)
    INPUT_TO_MOVE.find { |inputs, _| inputs.include?(input) }.last.new
  end
end

class Computer < Player
  attr_reader :preference

  @@subclasses = []

  def self.inherited(subclass)
    @@subclasses << subclass
  end

  def self.all
    @@subclasses
  end

  def choose
    self.move = (Move.all + Array.new(5, preference)).compact.sample.new
  end
end

class NormalBot < Computer
  def initialize
    @name = "Normal Bot"
  end
end

class GeicoGeckoBot < Computer
  def initialize
    @name = "Geico Gecko Bot"
    @preference = Lizard
  end
end

class MichaelScottBot < Computer
  def initialize
    @name = "Michael Scott Bot"
    @preference = Paper
  end
end

class DwayneJohnsonBot < Computer
  def initialize
    @name = "Dwayne Johnson Bot"
    @preference = Rock
  end
end

class LeonardNimoyBot < Computer
  def initialize
    @name = "Leonard Nimoy Bot"
    @preference = Spock
  end
end

class Scoreboard
  include Displayable
  attr_reader :human, :computer
  attr_accessor :history, :score

  WIN_SCORE = 10

  def initialize(human, computer)
    @history = []
    @human = human
    @computer = computer
    @score = { human => 0, computer => 0 }
  end

  def log(human_move, computer_move)
    history << { human => human_move, computer => computer_move }

    if human_move.beats?(computer_move)
      score[human] += 1
    elsif computer_move.beats?(human_move)
      score[computer] += 1
    end
  end

  def display_current_score
    prompt(score.map { |player, points| "#{player}: #{points}" }.join(' | '))
  end

  def game_over?
    score.any? { |_, points| points == WIN_SCORE }
  end

  def grand_winner
    score.key(WIN_SCORE)
  end

  def display_grand_winner
    if grand_winner == human
      prompt("You are the GRAND WINNER! Congratulations!")
    else
      prompt("#{computer} is the GRAND WINNER. Better luck next time.")
    end
  end

  def display_history
    prompt("Here's the game history:")
    history.each.with_index(1) do |round, index|
      moves = round.map { |player, move| "#{player} -> #{move}" }.join(' | ')
      prompt("  Round #{index}: #{moves}")
    end
  end

  def reset
    self.history = []
    score.keys.each { |player| score[player] = 0 }
  end
end

class RPSGame
  include Displayable
  attr_accessor :human, :computer, :scoreboard

  def initialize
    @human = Human.new
    @computer = Computer.all.sample.new
    @scoreboard = Scoreboard.new(human, computer)
  end

  def play
    initial_setup

    loop do
      display_welcome

      play_round until scoreboard.game_over?

      scoreboard.display_grand_winner
      scoreboard.display_history

      play_again? ? reset_game : break
    end

    display_goodbye
  end

  private

  def initial_setup
    clear_screen
    human.set_name
  end

  def display_welcome
    clear_screen
    welcome_message = <<~MSG
      Welcome to RPSLS, #{human}!
      You will play the #{computer} and each round will be a win, loss, or tie.
      Pay attention to the bot's name, because it might reveal its preference!
      The first to win #{Scoreboard::WIN_SCORE} rounds is the grand winner. GL!
    MSG
    prompt(welcome_message)
  end

  def display_round_moves
    prompt("#{human} chose: #{human.move}; "\
           "#{computer} chose: #{computer.move}.")
  end

  def win_message(winner, loser)
    "#{winner.move} #{winner.move.win_verb(loser.move)} #{loser.move}. "\
    "#{winner} won!"
  end

  def display_round_result
    human_move = human.move
    computer_move = computer.move

    if human_move.beats?(computer_move)
      prompt(win_message(human, computer))
    elsif computer_move.beats?(human_move)
      prompt(win_message(computer, human))
    else
      prompt("It's a tie!")
    end
  end

  def play_round
    human.choose
    computer.choose

    clear_screen

    display_round_moves
    display_round_result

    scoreboard.log(human.move, computer.move)
    scoreboard.display_current_score
  end

  def play_again?
    loop do
      prompt("Would you like to play again? (Y/N)")
      play_again = gets.chomp.strip.downcase
      if Displayable::VALID_YES_NO.include?(play_again)
        return play_again.start_with?('y')
      end
      prompt("Please enter Y/N.")
    end
  end

  def reset_game
    self.computer = (Computer.all - [computer]).sample.new
    self.scoreboard = Scoreboard.new(human, computer)
  end

  def display_goodbye
    prompt("Thanks for playing. Good bye!")
  end
end

RPSGame.new.play
