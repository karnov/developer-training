# Map, Select, and Other Enumerable methods

Earlier we learned about `Array` and `Hash` but only got half the story... they each have their own methods for adding and deleting and accessing data and they both implement their own version of the `#each` method to iterate over their items but what makes them really powerful in Ruby is the ability to use Enumerable methods as well as the basic ones you've just learned.

`Enumerable` is actually a `module`, which means it is just a bunch of methods packaged together that can (and do) get "mixed in", or included, with other classes (like Array and Hash.

That also means, that you new class can get all the same really useful methods like `#map` and `#select` "for free". All you have to do is to implement the `#each` method and `include Enumerable`.

## Iterating

If you wan't to know position in the array, you will use `Enumerable`'s `#each_with_index`, which will pass that position into the block as well:

```ruby
["Ruby", "Java", "love", "fun"].each_with_index do |item, index|
  print "#{item} " if index%2==0
end
Ruby love! => ["Ruby", "Java", "love!", "fun"]
```

## Filtering

What if I want to keep only the even numbers that are in an array? The traditional way would be to build some sort of loop that goes through the array, checks whether each element is even, and starts populating a temporary array that we will return at the end. It might look something like:

```ruby
def keep_evens(list = [])
  result_list = []

  list.each do |num|
    result_list << num if num % 2 == 0
  end

  result_list
end

keep_evens([1,2,3,4,100,111])
=> [2,4,6,8,100,111]
```

That's too much code and you'd be better served using `Enumerable`'s `#select` instead. It will run the block on every item of your object (whether array or hash or whatever) and return a new object that contains only those items for which the original block returned true:

```ruby
[1,2,3,4,100,111].select { |item| item % 2 == 0 }
=> [2,4,100]
```

But we wan't the odd numbers instead - then use `#reject` instead

```ruby
[1,2,3,4,100,111].reject { |item| item % 2 == 0 }
=> [1,3,111]
```

If we only need the first even number, then use `#detect`.

```ruby
[1,2,3,4,100,111].detect { |item| item % 2 == 0 }
=> 2

[1,3].detect { |item| item % 2 == 0 }
=> nil
```

## Map

Now you have filtered your data, let's say you wan't the squared value of these

```ruby
[1,2,3,4,100,111]
  .select { |item| item % 2 == 0 }
  .map { |item| item**2 }
=> [4,16,10000]
```

### Exercise

Extract the initials for each of a list of persons using `#map`, e.g. "Lars Ulrich", "Björn Borg", "Adam Price", "James Price"

## Sorting

Now we would like them sorted with the largest squared even value first

```ruby
[1,2,3,4,100,111]
  .select { |item| item % 2 == 0 }
  .map { |item| item**2 }
  .sort
  .reverse
=> [10000,16,4]
```

## Aggregation

Let's get the sum of the squared even values

```ruby
[1,2,3,4,100,111]
  .select { |item| item % 2 == 0 }
  .map { |item| item**2 }
  .sum
=> 10020
```

## Grouping

We could have taken another approach and started out grouping the numbers into odd and even

```ruby
[1,2,3,4,100,111].group_by { |item| item % 2 == 0 ? "odd" : "even" }
=> {"even"=>[1, 3, 111], "odd"=>[2, 4, 100]}
```

and wen't on from there. Maybe that could was a bit more selfexplaining, but we can do even better ...

## Some best practices

It's generally a good practise to avoid mixing up filtering, map'ing, aggregation, etc. in a single block. We could actually get the sum of the even squared values with a single block

```ruby
[1,2,3,4,100,111].sum { |item| item % 2 == 0 ? item**2 : 0 }
=> 10020
```

It's short, yes, but when you revisit that line of code in a month or so, you are probably going to spent some time understanding, what's going on.

And then you will feel an eager to add a comment, say

```ruby
# first finds even values, then sum the squares of those
[1,2,3,4,100,111].sum { |item| item % 2 == 0 ? item**2 : 0 }
=> 10020
```

The problem with comments are, that you now have too places to change. When you change the implementation you may also have to change the comment. Or they may eventually get out of sync...

You would be far better of using a few extra well-named methods.

```ruby
def even?(item)
  item % 2 == 0
end

def square_root(item)
  item ** 2
end

[1,2,3,4,100,111]
  .select { |item| even?(item) }
  .map { |item| square_root(item) }
  .sum
=> 10020
```

## The `&` operator shorthand

Ruby has a shorter way for writing blocks, that calls a method with the item as argument. I don't wan't to go into that, but here's how it could look.

```ruby
...

[1,2,3,4,100,111]
  .select(&method(:even?))
  .map(&method(:square_root))
  .sum
=> 10020
```

Sometimes the Ruby object you are using already provides the functionality you need, here e.g. `1.even?` will return `false`.

Let's rewrite. Finally we end up with

```ruby
def square_root(item)
  item ** 2
end

[1,2,3,4,100,111]
  .select(&:even?)
  .sum(&method(:square_root))
=> 10020
```

## Exercise

Sort `Person` objects by `lastname` then `firstname`.

## Exercise

Find `BankAccount`s that have a negative `balance`.

## Exercise

Return the full name of the `Person`s that have `BankAccount`s with a negative `balance`.
