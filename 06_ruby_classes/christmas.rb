require 'date'

def christmas_eve
  Date.new(Date.today.year, 12, 24)
end

def days_until_christmas
  (christmas_eve - Date.today).to_i 
end

puts "#{days_until_christmas} days until christmas"