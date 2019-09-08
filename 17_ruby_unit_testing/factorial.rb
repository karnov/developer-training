class Factorial
  def factorial_of(number)
    (1..number).inject(:*)
  end
end
