# Methods

Ruby methods always returns something, mostly what is on the last line. 

```ruby
def add(number1, number2)
  return number1 + number2
end

add(1, 3)
=> 4
```

Consequencely, we will avoid the `return` and be satisfied with.

```ruby
def add(number1, number2)
  number1 + number2
end
```

## "void" methods

In the example below, there is a call to `puts`, that will print to the console. But `puts` itself, and hence the `say_hello` method, will then returns `nil`.

```ruby
def say_hello(name)
  puts "Hello #{name}."
  puts "How are you?"
end

say_hello("Sunshine")
"Hello Sunshine."
"How are you?"
=> nil
```

## Guard clauses

But there are cases where you want to use `return`, namely if find yourself wrapping a method in a conditional. Say, we want to avoid printing hello if no name is given.

```ruby
def say_hello(name)
  if name
    puts "Hello #{name}."
    puts "How are you?"
  end
end
```

In such case you can use a guard, i.e. return early if `name` isn't set 

```ruby
def say_hello(name)
  return unless name

  puts "Hello #{name}."
  puts "How are you?"
end

say_hello
=> nil
```

Notice that there was nothing printed to `stdout` and `return` returned `nil` which it does by default.

Also notice, that we choose to just write `say_hello` instead of `say_hello()`, since paranthesises are optional.

## Default arguments

It's possible to set a default argument for `name`, in case the method is called without.

```ruby
def say_hello(name = "my friend")
  puts "Hello #{name}."
  puts "How are you?"
end

say_hello
"Hello my friend"
"How are you?"
=> nil
```

Since arguments can have default values there is no need and any way to overload methods.

```ruby
def say_hello(name)
  puts "Hello #{name}."
  puts "How are you?"
end

def say_hello
  say_hello("my friend")
end

say_hello("Batman")        
ArgumentError: wrong number of arguments (given 1, expected 0)
```

See, the first method `say_hello(name)`, which takes exactly one argument is overwritten by the second `say_hello()`, which takes no arguments. Thus, we get the expected argument error from the second method.

## Keyword arguments

Below, `mysterious_total` is a method that takes three arguments.

```ruby
def mysterious_total(subtotal, tax, discount)
  subtotal + tax - discount
end

mysterious_total(100, 10, 5)
=> 105
```

This method does its job, but as a reader of the code using the `mysterious_total` method, I have no idea what those arguments mean without looking up the implementation of the method.

By using keyword arguments, we know what the arguments mean without looking up the implementation of the called method:

```ruby
def obvious_total(subtotal:, tax:, discount:)
  subtotal + tax - discount
end

obvious_total(subtotal: 100, tax: 10, discount: 5) 
=> 105
```

Keyword arguments allow us to switch the order of the arguments, without affecting the behavior of the method:

```ruby
obvious_total(subtotal: 100, discount: 5, tax: 10)
=> 105
```

Of course, if we switch the order of the positional arguments in `mysterious_total`, we are not going to get the same results, giving our customers more of a discount than they deserve:

```ruby
mysterious_total(100, 5, 10)
=> 95
```

Ruby allows you to mix positional and keyword arguments and let some have default values

```ruby
def yet_another_total(subtotal, tax: 10, discount:)
  subtotal + tax - discount
end
yet_another_total(100, discount: 5)
=> 105
```

## Methods that evaluates to true or false

I mentioned earlier that methods always returns something. In case no other value, then `nil`, which is an instance of `NilClass` in Ruby, and thus another Ruby object.

A rather cool feature in Ruby is that `nil` will evaluate as `false` when used in a conditional. All other objects (except `false` of course) will evaluate to `true`. That allows us to make simple conditionals such as:

```ruby
def say_hello(name)
  if name
    puts "Hello #{name}"
  end
end
```

Notice how we don't have to check, e.g. if `name != nil` or `!name.nil?`. We can even put the conditional after the `puts` statement.

```ruby
def say_hello(name)
  puts "Hello #{name}" if name
end
```

But what if `name` is the empty string - we may need a method that checks whether `name` is meaningful.

```ruby
def name?(name)
  name.match(/[\w\s\-\.]{2,20}/)
end

def say_hello(name)
  puts "Hello #{name}" if name?(name)
end
```

Oh - but `name?("Jakob")` will actually return `"MatchData "Jakob"` and `name?("12345")` will return `nil`. 

But that's just fine, since `MatchData ...` and `nil` will evaluate to `true` and `false` respectively in the `if name?(name)` conditional.

For newcomers to Ruby this may be a bit suprising, but it's one way in which we can save a few lines of code here and there - for the sake of readability.

## nil and the safe navigation operator

In cases like here `name` can be either a string or `nil`. And unfortunately what would happen when calling `name?(nil)` is that `name` will complain with a `NoMethodError`

```ruby
name?(nil)
NoMethodError: undefined method `match' for nil:NilClass
```

That's more or less Ruby's equivalent to Java's NullPointerException, i.e. we thought it was a string, but it was `nil`.

In this exact case we could benefit from the fact that `NilClass` inherits the `to_s` from the basis class `Object`, which explicitely converts `nil` to the string value `""`. Since the empty string is a valid `String` object, it has a method `match` and we are fine.

```ruby
def name?(name)
  name.to_s.match(/[\w\s-\.]{2,20}/)
end
```

Another way is to use (what we realized before), that `nil` evaluates to false, etc. and use the and operator `&&`

```ruby
def name?(name)
  name && name.match(/[\w\s-\.]{2,20}/)
end
```

That's a common practice in Ruby and perhaps that is why there is a shorthand for that, the so-called safe navigation operator, which is replacing all trailing method calls e.g. `.methodname` with a `&.methodname`.

So we will end up with the very Ruby'sh

```ruby
def name?(name)
  name&.match(/[\w\s-\.]{2,20}/)
end
```

## The return value of case-when-then, if/else etc.

A common structure you will see in other non-functional programming languages is

```ruby
def artist(phrase_of_song)
  artist = nil
  
  case phrase_of_song
  when /Dub-I-Dub-I-Dub-I-Dup-Bup-Bup/
    artist = "Me & My"
  when /Waterloo/
    artist = "Abba"
  when /Smoooooke on the water/
    artist = "Deep Purple"
  end
  
  artist
end

artist("Waterloo I was defeated, you won the war")
=> "Abba"
```

It means artist will be a mutable

In ruby there is a more functional way of doing this. And that is because `case-when-then` and `if/else` works like functions and hence returns a value. So instead we would rather:

```ruby
def artist(phrase_of_song)
  case phrase_of_song
  when /Dub-I-Dub-I-Dub-I-Dup-Bup-Bup/
    "Me & My"
  when /Waterloo/
    "Abba"
  when /Smoooooke on the water/
    "Deep Purple"
  end
end

artist("Waterloo I was defeated, you won the war")
=> "Abba"
```