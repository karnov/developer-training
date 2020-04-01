require 'pathname'
require 'json'

module Saveable
  def to_h
    fail "You must implenent #to_h"
  end
  
  def id
    fail "You must implement #id"
  end

  def safe_id
    id.downcase.tr(" ", "_").gsub(/[^0-9a-z_-]/, "-")
  end

  def storage_path
    Pathname.new(__dir__).join("#{safe_id}.json")
  end

  def save
    storage_path.write(to_h.to_json)
  end
end

class SimpleAccount
  include Saveable
  attr_reader :balance, :owner_name, :account_name, :id
  
  def initialize(owner_name, account_name)
    @owner_name = owner_name
    @account_name = account_name
    @balance = 0
  end

  def id
    "#{owner_name}-#{account_name}"
  end

  def to_h
    {
      owner_name: owner_name,
      account_name: account_name,
      balance: balance
    }
  end

  def deposit(amount)
    @balance = @balance + amount
  end

  def withdraw(amount)
    @balance = @balance - amount
  end
end

new_account = SimpleAccount.new("John Best", "Budget")
new_account.deposit(150.0)

puts "Dumping to json"
new_account.save

puts "The content of john_best-budget.json is"
puts File.read(File.join(__dir__, "john_best-budget.json"))