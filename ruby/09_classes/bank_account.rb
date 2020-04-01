class BankAccount
  attr_reader :balance, :owner
  
  def initialize(owner:)
    @owner = owner
    @balance = 0
  end

  def deposit(amount)
    @balance = @balance + amount
  end

  def withdraw(amount)
    @balance = @balance - amount
  end
end