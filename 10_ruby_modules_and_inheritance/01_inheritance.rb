class Person
  attr_reader :firstname, :lastname

  def initialize(personal_identity_number:, firstname:, lastname:)
    @personal_identity_number = personal_identity_number
    @firstname = firstname
    @lastname = lastname
  end

  def full_name
    "#{firstname} #{lastname}"
  end

  def birthdate
    Date.strptime(date_str, "%y%m%d")
  rescue ArgumentError
    fail "Wrong date error"
  end

  private
  
  attr_reader :personal_identity_number

  def date_str
    personal_identity_number[/\A(?<date>\d{8})-\d{6}\z/, :date]
  end
end

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

class InterestBearingAccount < BankAccount
  def initialize(owner:, rate:)
    super(owner: owner)
    @rate = rate
  end

  def deposit_interest
    @balance += @rate * @balance
  end
end

owner = Person.new \
  personal_identity_number: "811228-9874",
  firstname: "John",
  lastname: "Best"

require 'pry'; binding.pry
account = InterestBearingAccount.new(owner: owner, rate: 0.1)
account.deposit(200.0)

puts account.balance

account.deposit_interest

puts account.balance