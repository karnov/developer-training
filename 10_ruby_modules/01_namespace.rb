module BirtdayCalculator
  class Integer
    def abs
      60
    end
  end
end

number = BirtdayCalculator::Integer.new(-3)
puts number.abs

puts -3.abs