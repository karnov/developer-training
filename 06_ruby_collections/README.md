# Collections

## Arrays

### Creation

```ruby
numbers = [1, 0, 7] # or Array.new([1,0,7])

numbers[2]
=> 7

numbers.size
=> 3
```

Arrays do not need to consist of the same data type.

```ruby
data = ["bob", 3, 0.931, true]
```

As for Strings, Ruby provides some other syntax shortcuts through [%notation](http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals#The_.25_Notation).

```ruby
%w{A list of words}
=> ["A", "list", "of", "words"]
```

### Array indices

Most languages will throw an exception if you attempt to access an array index that does not yet exist. If you attempt to read a non-existent index, Ruby returns nil.

```ruby
letters = ['a', 'b', 'c']

letters[2]
=> 'c'

letters[3]
=> nil
```

### Adding and removing elements

```ruby
[1,2,3] << "a" 
=> [1,2,3,"a"]

[1,2,3].push("a")
=> [1,2,3,"a"]

list = [1,2,3]
list.pop
=> 3
list
=> [1,2]

list = ["a",1,2,3]
list.shift
=> "a"
list
=> [1,2,3]

[1,2,3] << [4,5,6]
=> [1,2,3,[4,5,6]]
```

### Combining arrays

```ruby
[1,2,3] + [4,5,6]
=> [1,2,3,4,5,6]

[1,2,3] - [2,3,4]
=> [1,4]

[1,2,3] & [2,3,4]
=> [2,3]
```

### Sorting arrays

is simply

```ruby
[3,1,2,2].sort
=> [1,2,2,3]
```

You can get the unique entries

```ruby
[3,1,2,2].uniq
=> [3,1,2]
```

but perhaps what you are looking for is a `Set` or `SortedSet`

```ruby
require 'set'

SortedSet.new([3,1,2,2])                                   => #<SortedSet: {1, 2, 3}>
```

## Hashes

### Creation

Like arrays, hashes have both literal and constructor initialization syntax.

```ruby
colors = {}
colors['red'] = 0xff0000

colors = Hash.new
colors['red'] = 0xff0000
```

As with arrays, it’s possible to create a hash with starting values. This is where we get to see the idiomatic `=>` (“hash rocket”).

```ruby
colors = {
  'red'  => 0xff0000,
  'blue' => 0x0000ff
}

=> {"red"=>16711680,"blue"=>255}
```

### To `=>` or Not to `=>`

It’s popular to use symbols as the Hash keys because they are descriptive like strings but fast like integers.

```ruby
colors = {
  :red  => 0xff0000,
  :blue => 0x0000ff
}

=> {:red=>16711680, :blue=>255}
```

Starting with Ruby 1.9 (a long time ago), hashes whose keys are symbols can be built without hash rocket (`=>`), looking more like JavaScript or Python.

```ruby
colors = {
  red:  0xff0000,
  blue: 0x0000ff
}

=> {:red=>16711680, :blue=>255}
```

### Adding/fetching new entries

```ruby
colors = {
  red:  0xff0000,
  blue: 0x0000ff
}

colors[:red]
```

Notice, if you try to access a hash key with no value, it will return nil. 

```ruby
colors[:green]
=> nil
```

Use `.fetch()` in case you wan't to throw an error or return a default value, when there's no hash key with a value.

```ruby
colors = {
  'red'  => 0xff0000,
  'blue' => 0x0000ff
}

colors.fetch(:green)
=> KeyError: key not found: :green

colors.fetch(:green, 0xffffff)
=> 0xffffff
```
