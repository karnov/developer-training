require 'rspec'
require './factorial'

describe Factorial do
  it "finds the factorial of 5" do
    calculator = Factorial.new

    expect(calculator.factorial_of(5)).to eq(120)
  end
end
