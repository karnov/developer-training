# Ruby classes

When we earlier on discussed functions, we saw how keyword arguments could be used to make a method with multiple arguments easier to read.

Say we have a method that takes bank account details as argument.

```ruby
def bank_statement_pdf(account_balance:, account_firstname:, account_lastname:, account_personal_identity_number:, , ...)
```

You get the idea, it may be better for us to let a bank_account object carry that knowledge.

## Struct

Ruby `Struct`s are quite good for carrying data around. It works more or less the same way as `struct` in `C` and many other derivatives.

First we will define a new type, `BankAccount` that is a `Struct` with attributes `balance`, `firstname`, `lastname` and `personal_identity_number` and create a new object `account` of that type.

```ruby
BankAccount = Struct.new(:balance, :firstname, :lastname, :personal_identity_number)

account = BankAccount.new(200, "John", "Best", "811228-9874")

puts account.balance
=> 200
```

It is also possible to add methods to structs

```ruby
BankAccount = Struct.new(:balance, :firstname, :lastname, :personal_identity_number) do
  def full_name
    "#{firstname} #{lastname}"
  end
end

account = BankAccount.new(200, "John", "Best", "811228-9874")

puts account.full_name
=> "John Best"
```

And yes, `Struct`s are an awesome way of carrying complex data around (instead of just a `Hash`). They will give you `get`/`set`'ers for all instance variables (i.e. what's in `@balance`, `@personal_identity_number`, `@firstname`, `@lastname`) right out of the box.

```ruby
account.public_methods
=> [:personal_identity_number,
 :personal_identity_number=,
 :balance,
 :balance=,
 :firstname,
 :firstname=,
 :lastname,
 :lastname=,
 ...
 ```

But the drawback is, that all attributes and methods are `public`, i.e. read/write accessible. 

Do we really want write access to `@balance` and should we be able to read `@personal_identity_number` from outside. 

```ruby
account.balance = 1_000_000_000
puts account.balance
=> 1000000000

puts account.personal_identity_number
=> "811228-9874"
```

Perhaps not.

All these "requirements make the `BankAccount` type a good candidate for a `class`.

```ruby
class Person
  def initialize(
      personal_identity_number: personal_identity_number, 
      firstname: firstname, 
      lastname: lastname)
    @personal_identity_number = personal_identity_number
    @firstname = firstname
    @lastname = lastname
  end
end

class BankAccount
  def initialize(owner:)
    @owner = owner
    @balance = 0
  end

  def deposit(amount)
    @balance = @balance + amount
  end

  def withdraw(amount)
    @balance = @balance - amount
  end
end

owner = Person.new \
  personal_identity_number: "811228-9874",
  firstname: "John",
  lastname: "Best"

account = BankAccount.new(owner: owner)
account.deposit(200)
```

## The `initialize` method

`initialize` is the method entered when calling `.new` on a class.

It is used the same way you would use a constructor method in other object oriented languages, e.g. to set instance variables. For the `BankAccount` we will take a `Person` object as an argument `owner` and store that in the instance variable `@owner`. We will also set the `@balance` to `0`.

## Getter/setter methods

Now in order to read the balance, we could make a "get balance" method method in `BankAccount`. Then Ruby way(TM) is to avoid the `get_` and `set_` prefixes, hence:

```ruby
def balance
  @balance
end
```

But for methods which only accesses (read or write) an instance variable, within the object, Ruby (of course) has a shorthand for that

```ruby
attr_reader :read_only_instancevariable, ... 
attr_writer :write_only_instance_variable, ...
attr_accessor :read_and_write....
```

Hence our `BankAccount` class will become

```ruby
class BankAccount
  attr_reader :balance, :owner
  
  def initialize(owner:)
    @owner = owner
    @balance = 0
  end

  def deposit(amount)
    @balance = @balance + amount
  end

  def withdraw(amount)
    @balance = @balance - amount
  end
end
```

We introduces a method `full_name` in the `Person` class, that puts the `@firstname` and `@lastname` together. 

Note also, that when we make have `attr_reader :firstname, :lastname` in `Person`, the getter-methods `firstname` and `lastname` can be used instead of `@firstname` and `@lastname` in `full_name` outside as well as inside `Person`.

```ruby
class Person
  attr_reader :firstname, :lastname

  def initialize(personal_identity_number:, firstname:, lastname:)
    @personal_identity_number = personal_identity_number
    @firstname = firstname
    @lastname = lastname
  end

  def full_name
    "#{firstname} #{lastname}"
  end
end

owner = Person.new \
  personal_identity_number: "811228-9874",
  firstname: "John",
  lastname: "Best"

account = BankAccount.new(owner: owner)
account.deposit(200)

puts account.balance
=> 200

puts account.owner.firstname
=> "John"

puts account.owner.full_name
=> "John Best"
```

## Exercise

Add a `birthday` method to `Person`, that returns a Ruby `Date` object with the account owners birthday date calculated from the `@personal_identity_number`-number. You may want to use some code from an earlier exercise.

## Exercise

Try restructure the code so that a `Person` can have multiple `BankAccount`s, say a budget account and a saving account.

## Exercise

Enhance it so that a `Person` can transfer money from one `BankAccount` to another. Perhaps also another persons account.