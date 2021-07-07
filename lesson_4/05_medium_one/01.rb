class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

p BankAccount.new(50).positive_balance?

# Ben is right, because there is an `attr_reader` added for the balance instance variable. By calling the `balance` method, `@balance` is returned.