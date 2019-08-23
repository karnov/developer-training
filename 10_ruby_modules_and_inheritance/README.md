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
    def abs
      60
    end
  end
end

number = BirtdayCalculator::Integer.new(-3)
number.abs
=> 60
```

Ruby 2.0 introduced a *pollite* way of monkey patching, [refinements](https://ruby.programmingpedia.net/en/tutorial/6043/monkey-patching-in-ruby#safe-monkey-patching-with-refinements)

But still, you should namespace your functionality.
In a later lesson we will see, that `gem` packages embeds all code within a namespace, which (by convention) have the same name as the `gem`, i.e. our imaginary `gem` called `birthday_calculator.gem` should be used in the following way

```ruby
require 'birthday_calculator'
calculator = BirtdayCalculator::Calculator.new
calculator.days_until(month: 12, day: 24)
```

# Inheritance

There is an acronym that you'll see often in the Ruby community, *DRY* - "Don't Repeat Yourself". It means that if you find yourself writing the same logic over and over again in your programs, there are ways to extract that logic to one place for reuse.

In this lesson we will explore the two primary ways that Ruby implements inheritance, class inheritance and mixing in modules (a.k.a. composition)

## Class inheritance

Our bank business have evolved, so we wan't to add a `InterestBearingAccount` to our code project.
We use `<` to let `InterestBearingAccount` inherit from `BankAccount`.

```ruby
require_relative '../09_ruby_classes/bank_account'

class InterestBearingAccount < BankAccount
  def initialize(owner:, rate:)
    @owner = owner
    @balance = 0.0
    @rate = rate
  end

  def deposit_interest
    @balance += @rate * @balance
  end
end

owner = Person.new \
  personal_identity_number: "811228-9874",
  firstname: "John",
  lastname: "Best"

account = InterestBankAccount.new(owner: owner, rate: 0.1)
account.deposit(200.0)

account.balance
=> 200.0

account.deposit_interest

account.balance
=> 220.0
=> 
```

Ruby provides us with a built-in function called `super` that allows us to call methods up the inheritance hierarchy. When you call `super` from within a method, it will search the inheritance hierarchy for a method by the same name and then invoke it. Let's modify `InterestBearingAccount`

```ruby
class InterestBearingAccount < BankAccount
  def initialize(owner:, rate:)
    super(owner: owner)
    @rate = rate
  end

...
```

### Abstract classes

In many object oriented languages, such as Java, there are abstract classes. Abstract classes are classes which cannot be instantiating, but can share common functionality to concrete classes, which inherits from it.

In Ruby you can of course make a class abstract, but only by naming it, say `AbstractAccount`. Ruby won't refrain you from instantiating it.

## Mixin in modules (Composition)

Ruby do not have interfaces like Java.

Instead a `module` can define methods that can be shared in different classes either at the class or instance level. This technique is referred to as `mixin` or `composition`.

Below `Saveable` extends `SimpleAccount` with the ability to dump the account's state into a json file.

```ruby
module Saveable
  def to_h
    fail "You must implenent #to_h"
  end
  
  def id
    fail "You must implement #id"
  end

  def safe_id
    id.downcase.tr(" ", "_").gsub(/[^0-9a-z_-]/, "-")
  end

  def storage_path
    Pathname.new(__dir__).join("#{safe_id}.json")
  end

  def save
    storage_path.write(to_h.to_json)
  end
end

class SimpleAccount
  include Saveable

  attr_reader :balance, :owner_name, :account_name, :id
  
  def initialize(owner_name, account_name)
    @owner_name = owner_name
    @account_name = account_name
    @balance = 0
  end

  def id
    "#{owner_name}-#{account_name}"
  end

  def to_h
    {
      owner_name: owner_name,
      account_name: account_name,
      balance: balance
    }
  end

  ...
end

new_account = SimpleAccount.new("John Best", "Budget")
new_account.deposit(150.0)
new_account.save
```

It is not hard to imagine, that such a feature could be used in our `Person` class too. 

Did you notice the name of the module? A common naming convention for Ruby is to use the "able" suffix on whatever verb describes the behavior that the module is modeling.

## Class inheritance or mixin in modules?

Now that you know the two primary ways that Ruby implements inheritance, class inheritance and mixing in modules, you may wonder when to use one vs the other. Here are a couple of things to remember when evaluating those two choices.

-   You can only subclass from one class. But you can mix in as many modules as you'd like.
-   If it's an "is-a" relationship, choose class inheritance. If it's a "has-a" relationship, choose modules. Example: a dog "is an" animal; a dog "has an" ability to swim.
-   You cannot instantiate modules (i.e., no object can be created from a module). Modules are used only for namespacing and grouping common methods together.
