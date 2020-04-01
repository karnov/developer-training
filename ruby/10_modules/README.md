# Modules

Modules can be used to group functionality. Therefore one of it's usages are, to define namespaces in your code.

## Why use namespaces?

Say you are defining your own `Integer` class, with a method called `abs`.

```ruby
class Integer
  def abs
    60
  end
end
```

Let's say that your code was used by your colleague in a big project and he was about to calculate the absolute value of an `-3`, which is an instance of the `Integer` class.

```ruby
-3.abs
=> 60
```

Oops, that wasn't expected.

What you did is, what is known as [*monkey patching*](https://ruby.programmingpedia.net/en/tutorial/6043/monkey-patching-in-ruby), you have overwritten the core `Integer` class in Ruby. That same thing could happen with any core or standard library class in Ruby.

If you really, really think you need another `Integer` class, then embedding it in a namespace, e.g. `BirthdayCalculator` would be an option.

```ruby
module BirtdayCalculator
  class Integer
    def initialize(num)
      @num = num
    end

    def abs
      60
    end
  end
end

number = BirtdayCalculator::Integer.new(-3)
number.abs
=> 60

-3.to_i
=> 3
```

Ruby 2.0 introduced a *pollite* way of monkey patching, [refinements](https://ruby.programmingpedia.net/en/tutorial/6043/monkey-patching-in-ruby#safe-monkey-patching-with-refinements)

But still, you should namespace your functionality.
In a later lesson we will see, that `gem` packages embeds all code within a namespace, which (by convention) have the same name as the `gem`, i.e. our imaginary `gem` called `birthday_calculator.gem` should be used in the following way

```ruby
require 'birthday_calculator'
calculator = BirtdayCalculator::Calculator.new
calculator.days_until(month: 12, day: 24)
```