numbers = [1, 0, 7] 
puts numbers[2]
puts numbers.size

puts ["bob", 3, 0.931, true]

puts %w{A list of words}

letters = ['a', 'b', 'c']
puts letters[2]
puts letters[3]

puts [1,2,3] << "a" 

puts [1,2,3].push("a")

list = [1,2,3]
puts list.pop
puts list

list = ["a",1,2,3]
puts list.shift
puts list

puts [1,2,3] << [4,5,6]

### Combining arrays

puts [1,2,3] + [4,5,6]

puts [1,2,3] - [2,3,4]

puts [1,2,3] & [2,3,4]

puts [3,1,2,2].sort

puts [3,1,2,2].uniq

require 'set'
puts SortedSet.new([3,1,2,2])