require 'roman-numerals'

class Stuff
  def initialize(num)
    @num = num
  end

  def transform
    RomanNumerals.to_roman(@num)
  end
end

puts Stuff.new(3).transform
