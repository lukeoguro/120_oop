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

  def empty_line
    puts ""
  end

  def enter_to_continue
    prompt("Press enter to continue:")
    gets.chomp
  end

  def valid_int?(input)
    input.to_i.to_s == input
  end
end

class Card
  FACES = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]
  SUITS = %w(♠ ♥ ♣ ♦)

  COURTS = ["J", "Q", "K"]
  COURTS_VALUE = 10

  ACE = "A"
  ACE_VALUE = [1, 11]

  attr_reader :face

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def to_s
    "[#{face}#{suit}]"
  end

  alias inspect to_s

  private

  attr_reader :suit
end

class Deck
  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::FACES.each do |face|
        @cards << Card.new(suit, face)
      end
    end
    cards.shuffle!
  end

  def pop
    cards.pop
  end

  private

  attr_reader :cards
end

class Hand
  include Displayable

  def initialize
    @cards = []
  end

  def <<(card)
    cards << card
  end

  def size
    cards.size
  end

  def first
    cards.first
  end

  def last
    cards.last
  end

  def drawn_cards
    cards.select.with_index { |_, index| index >= 2 }
  end

  def format
    cards.join(' ')
  end

  def reset
    self.cards = []
  end

  def total
    faces = cards.map(&:face)
    total = 0
    faces.each do |face|
      if (2..10).include?(face)
        total += face
      elsif Card::COURTS.include?(face)
        total += Card::COURTS_VALUE
      end
    end
    adjust_for_aces(faces, total)
  end

  private

  attr_accessor :cards

  def adjust_for_aces(faces, total)
    faces.count(Card::ACE).times do
      total += if total + Card::ACE_VALUE.max <= TwentyOneGame::TARGET_VALUE
                 Card::ACE_VALUE.max
               else
                 Card::ACE_VALUE.min
               end
    end
    total
  end
end

class Participant
  include Displayable

  def initialize
    @hand = Hand.new
  end

  def add_card(card)
    @hand << card
  end

  def show_hand
    message = "#{name}: #{hand.format} => #{hand.total}"
    prompt(message)
  end

  def busted?
    hand.total > TwentyOneGame::TARGET_VALUE
  end

  def last_drawn_card
    hand.last
  end

  def hit_count
    hand.drawn_cards.count
  end

  def total
    hand.total
  end

  def to_s
    name
  end

  def reset_hand
    hand.reset
  end

  private

  attr_accessor :name
  attr_reader :hand
end

class Player < Participant
  CHOICES = { hit: 1, stay: 2 }

  def set_name
    input = nil
    loop do
      prompt("Before we start, what's your name?")
      input = gets.chomp.strip.capitalize
      break unless input.empty?
      prompt("Please enter a valid name.")
    end
    self.name = input
  end

  def hit?
    input = nil
    loop do
      prompt("Press '#{CHOICES[:hit]}' to hit, '#{CHOICES[:stay]}' to stay:")
      input = gets.chomp.strip
      break if CHOICES.values.include?(input.to_i) && valid_int?(input)
      prompt("Sorry, that's not a valid choice.")
    end
    input.to_i == CHOICES[:hit]
  end

  def first_move?
    hand.size == 2
  end
end

class Dealer < Participant
  STAY_VALUE = 17

  def initialize
    super
    self.name = %w(R2-D2 C-3PO BB-8).sample
  end

  def hit?
    hand.total < STAY_VALUE
  end

  def show_partial_hand
    message = "#{name}: #{hand.first} [  ]"
    prompt(message)
  end
end

class TwentyOneGame
  include Displayable

  TARGET_VALUE = 21

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def play
    set_up_game
    loop do
      deal_starting_hands
      player_turn
      dealer_turn unless player.busted?
      display_game_results
      play_again? ? reset_game : break
    end
    display_goodbye
  end

  private

  attr_accessor :deck
  attr_reader :player, :dealer

  def set_up_game
    display_welcome
    player.set_name
    display_participant_names
    enter_to_continue
  end

  def display_welcome
    message = <<~MSG
      Welcome to the command line Twenty-One game!
      The goal of Twenty-One is to get as close to #{TARGET_VALUE} \
      as possible without going over.
    MSG
    clear_and_prompt(message)
  end

  def display_participant_names
    message = <<~MSG
      Welcome, #{player}! The dealer is #{dealer}.
      Continue when you're ready. Good luck!
    MSG
    clear_and_prompt(message)
  end

  def deal_starting_hands
    2.times do
      player.add_card(deck.pop)
      dealer.add_card(deck.pop)
    end
  end

  def player_turn
    loop do
      clear_screen
      show_partial_hands
      display_player_turn_message
      player.hit? ? player.add_card(deck.pop) : break
      break if player.busted?
    end
  end

  def show_partial_hands
    dealer.show_partial_hand
    player.show_hand
    empty_line
  end

  def display_player_turn_message
    message = if player.first_move?
                "#{dealer} dealt the initial cards."
              else
                "You chose to hit. The total is now #{player.total}."
              end
    prompt(message)
  end

  def dealer_turn
    while dealer.hit?
      dealer.add_card(deck.pop)
    end
  end

  def display_game_results
    clear_screen
    show_hands
    if player.busted?
      display_player_turn_message
    else
      display_dealer_turn_message
    end
    display_winner
  end

  def show_hands
    dealer.show_hand
    player.show_hand
    empty_line
  end

  def display_dealer_turn_message
    if dealer.hit_count == 0
      prompt("#{dealer} chose not to hit.")
    else
      prompt("#{dealer} chose to hit #{dealer.hit_count} time(s).")
    end
  end

  def display_winner
    prompt(winning_message(player.total, dealer.total))
  end

  def winning_message(player_total, dealer_total)
    if player.busted?
      "You busted, #{dealer} wins."
    elsif dealer.busted?
      "#{dealer} busted, you win!"
    elsif dealer_total == player_total
      "The scores are even at #{dealer_total}. It's a tie."
    else
      winner = (player_total > dealer_total ? player : dealer)
      "#{winner} had the better score at #{winner.total}. #{winner} won!"
    end
  end

  def play_again?
    loop do
      prompt("Would you like to play again? (Y/N)")
      input = gets.chomp.strip.downcase
      if Displayable::VALID_YES_NO.include?(input)
        return input.start_with?('y')
      end
      prompt("Please enter Y/N.")
    end
  end

  def reset_game
    self.deck = Deck.new
    player.reset_hand
    dealer.reset_hand
  end

  def display_goodbye
    prompt("Thanks for playing. Good bye!")
  end
end

TwentyOneGame.new.play
