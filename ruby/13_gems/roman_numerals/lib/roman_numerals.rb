require "roman_numerals/version"

module RomanNumerals
  class Error < StandardError; end

  class NotANumberError < RomanNumerals::Error; end
  def self.to_roman(number)

    "III"
  end
end
