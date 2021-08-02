module Displayable
  VALID_YES_NO = ['y', 'yes', 'n', 'no']

  def prompt(message)
    message.each_line { |line| puts "=> #{line}" }
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def clear_and_prompt(message)
    clear_screen
    prompt(message)
  end

  def valid_int?(input)
    input.to_i.to_s == input
  end

  def enter_to_continue
    prompt("Press enter to continue:")
    gets.chomp
  end

  def joinor(arr, delimiter=', ', word='or')
    case arr.size
    when 0 then ''
    when 1 then arr[0]
    when 2 then arr.join(" #{word} ")
    else        "#{arr[0..-2].join(delimiter)}#{delimiter}#{word} #{arr[-1]}"
    end
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  SIZE = 3
  CENTER_KEY = 5

  def initialize
    @squares = (1..9).map { |key| [key, Square.new] }.to_h
  end

  def to_s
    <<~MSG
         |     |
      #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}
         |     |
    -----+-----+-----
         |     |
      #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}
         |     |
    -----+-----+-----
         |     |
      #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}
         |     |
    MSG
  end

  def unmarked_keys
    squares.keys.select { |key| @squares[key].unmarked? }
  end

  def []=(key, marker)
    squares[key].marker = marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      markers = squares.values_at(*line).select(&:marked?).map(&:marker)
      return markers.first if markers.size == SIZE && markers.uniq.size == 1
    end
    nil
  end

  def someone_won?
    !!winning_marker
  end

  def full?
    unmarked_keys.empty?
  end

  def reset_markers!
    squares.each_value(&:reset_marker!)
  end

  def third_square_key(marker)
    WINNING_LINES.each do |line|
      if squares.values_at(*line).map(&:marker).count(marker) == (SIZE - 1)
        line.each do |key|
          return key if squares[key].marker == Square::INITIAL_MARKER
        end
      end
    end
    nil
  end

  private

  attr_reader :squares
end

class Square
  attr_accessor :marker

  INITIAL_MARKER = " "

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def reset_marker!
    self.marker = INITIAL_MARKER
  end
end

class Player
  attr_accessor :marker, :score

  def to_s
    name
  end

  private

  attr_accessor :name
end

class Human < Player
  include Displayable

  DEFAULT_MARKER = "X"

  def set_name
    input = nil
    loop do
      prompt("What's your name?")
      input = gets.chomp.strip.capitalize
      break unless input.empty?
      prompt("Please enter a valid name.")
    end
    self.name = input
  end

  def set_marker
    input = nil
    loop do
      prompt("Choose a single character as your marker "\
        "(press enter for default '#{DEFAULT_MARKER}'):")
      input = gets.chomp.strip
      break if input.empty? || input.size == 1
      prompt("Please enter a valid character.")
    end
    self.marker = (input.empty? ? DEFAULT_MARKER : input)
  end

  def choose_move(board)
    puts "Choose a square (#{joinor(board.unmarked_keys)}):"
    input = nil
    loop do
      input = gets.chomp
      break if valid_int?(input) && board.unmarked_keys.include?(input.to_i)
      puts "Sorry, that's not a valid choice."
    end
    board[input.to_i] = marker
  end
end

class Computer < Player
  DEFAULT_MARKER = "O"
  ALT_MARKER = "X"

  def initialize
    self.name = %w(R2-D2 C-3PO BB-8).sample
    self.marker = DEFAULT_MARKER
  end

  def ensure_unique_marker(other_marker)
    self.marker = ALT_MARKER if marker.casecmp?(other_marker)
  end

  def choose_move(board, other_marker)
    board[best_move(board, other_marker)] = marker
  end

  private

  def best_move(board, other_marker)
    board.third_square_key(marker) ||
      board.third_square_key(other_marker) ||
      (Board::CENTER_KEY if board.unmarked_keys.include?(Board::CENTER_KEY)) ||
      board.unmarked_keys.sample
  end
end

class TTTGame
  include Displayable

  WIN_SCORE = 5

  CHOICES = { human: 1, computer: 2, random: 3 }

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
  end

  def play
    display_welcome
    collect_information

    loop do
      play_game
      break unless game_over? && play_game_again?
    end

    display_goodbye
  end

  private

  attr_accessor :current_player, :starting_player
  attr_reader :human, :computer, :board

  def display_welcome
    message = <<~MSG
      Welcome to command-line Tic Tac Toe!
      You will play #{computer} and each round will be a win, loss, or tie.
      The first to win #{WIN_SCORE} rounds is the grand winner. Good luck!
    MSG
    clear_and_prompt(message)
  end

  def collect_information
    prompt("First, we need some basic information for the game.")
    human.set_name

    clear_and_prompt("Welcome, #{human}!")
    set_starting_player

    clear_and_prompt("Great! #{starting_player} will start each round.")
    human.set_marker
    computer.ensure_unique_marker(human.marker)

    clear_and_prompt("Good choice! Your marker is '#{human.marker}'. "\
      "We're all set, let's play!")
    enter_to_continue
  end

  def set_starting_player
    input = nil
    loop do
      prompt("Who goes first in each round? "\
        "#{CHOICES[:human]}) Player, #{CHOICES[:computer]}) #{computer}, "\
        "#{CHOICES[:random]}) Random")
      input = gets.chomp.strip
      break if valid_int?(input) && CHOICES.values.include?(input.to_i)
      prompt("That's not a valid choice.")
    end
    self.starting_player = convert_input_to_player(input.to_i)
  end

  def convert_input_to_player(input)
    case input
    when CHOICES[:human] then human
    when CHOICES[:computer] then computer
    when CHOICES[:random] then [human, computer].sample
    end
  end

  def play_game
    set_scores_to_zero

    loop do
      play_round
      break if game_over? || !continue_game?
    end

    display_game_winner if game_over?
  end

  def set_scores_to_zero
    human.score = 0
    computer.score = 0
  end

  def play_round
    self.current_player = starting_player

    loop do
      display_board if current_player == human
      current_player_move
      break if board.someone_won? || board.full?
      switch_current_player
    end

    post_round
  end

  def display_board
    clear_and_prompt("Your marker is '#{human.marker}' and "\
      "#{computer}'s marker is '#{computer.marker}'.")
    puts ""
    puts board
    puts ""
  end

  def current_player_move
    if current_player == human
      human.choose_move(board)
    else
      computer.choose_move(board, human.marker)
    end
  end

  def switch_current_player
    self.current_player = (current_player == human ? computer : human)
  end

  def post_round
    display_board
    display_round_winner

    log_score
    display_score

    board.reset_markers!
  end

  def display_round_winner
    case board.winning_marker
    when human.marker    then prompt "You won!"
    when computer.marker then prompt "#{computer} won!"
    else                      prompt "It's a tie!"
    end
  end

  def log_score
    case board.winning_marker
    when human.marker    then human.score += 1
    when computer.marker then computer.score += 1
    end
  end

  def display_score
    prompt("#{human}: #{human.score} | #{computer}: #{computer.score}")
  end

  def game_over?
    [human, computer].any? { |player| player.score == WIN_SCORE }
  end

  def continue_game?
    loop do
      prompt("Press any key to continue, or 'Q' to quit the game early.")
      input = gets.chomp.strip.downcase
      return input != 'q'
    end
  end

  def display_game_winner
    if human.score == WIN_SCORE
      prompt("You won the game! Congratulations!")
    else
      prompt("#{computer} won the game. Better luck next time.")
    end
  end

  def play_game_again?
    loop do
      prompt("Would you like to reset the score and play the game again? (Y/N)")
      input = gets.chomp.strip.downcase
      if Displayable::VALID_YES_NO.include?(input)
        return input.start_with?('y')
      end
      prompt("Please enter Y/N.")
    end
  end

  def display_goodbye
    prompt("Thanks for playing. Good bye!")
  end
end

TTTGame.new.play
