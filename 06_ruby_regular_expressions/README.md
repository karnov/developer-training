# Regular expressions

Creating a regular expression

```ruby
potus_regex = /(?:Trump|Obama|Bush|Clinton)/i

potus_regex.match("President Obama")
=> #<MatchData "Obama"

potus_regex.match("John Best")
=> nil
```

Instead of `/.../i` you can use `%r{...}i`, ie. `%r{(?:Trump|Obama|Bush|Clinton)}i`

## Capture groups

Often regular expressions are used to extract parts of a string, marking them with a caputure group `(...)`, such as

```ruby
CONTACT_REGEX = %r{name:\s+([\w\s]+)\s+address:\s+([\w\s]+)\s+phone:\s+(\d{8})}

contact = <<~txt
  name:      John Best
  address:   Megastreet 120
  phone:     24657890
txt
phone = contact[CONTACT_REGEX, 2]
```

## Named caputure groups

But named captures makes it easier to read

```ruby

CONTACT_REGEX = %r{name:\s+(?<name>[\w\s]+)\s+address:\s+(?<address>[\w\s]+)\s+phone:\s+(?<phone>\d{8})}

contact = <<~txt
  name:      John Best
  address:   Megastreet 120
  phone:     24657890
txt
phone = contact[CONTACT_REGEX, :phone]
```

## The `x`-flag

When your regular expressions gets hard to read, a good tip is to use the 'x'-flag, which allows you to split the expression over multiple lines - and it even allows you add comments

```ruby
CONTACT_REGEX = %r{
  name:\s+(?<name>[\w\s]+)\s+        # name:    John Best
  address:\s+(?<address>[\w\s]+)\s+  # address: Mystreet 2
  phone:\s+(?<phone>\d{8})           # phone:   12345678
}x

contact = <<~txt
  name:      John Best
  address:   Megastreet 120
  phone:     24657890
txt
phone = contact[CONTACT_REGEX, :phone]

# or ...
phone, name, address = CONTACT_REGEX
  .match(contact)
  .values_at(:phone, :name, :address)
```

## String substitution

Regular expressions are often used with string substituion.

```ruby
"Mary had a little lamb".sub(/little (?:lamb|cow)/, "iPad")
```

## Fidling with regular expressions

You may find [rubular.com/](https://rubular.com/) a useful tool when fiddling around with regular expressions in Ruby

## Exercise

[Swedish personal identity number](https://en.wikipedia.org/wiki/Personal_identity_number_(Sweden)) (personnummer) is a 10-digit number containing the persons birthday date.

Use a regular expression to extract the birthday from a personal identity number, e.g. 811228-9874, a person who was born December 28th 1981.

## Exercise

Turn it into a proper Ruby `Date` object.

Hint:

```ruby
require 'date'

date = Date.new(2019, 2, 27)
puts date.month
=> 2

another_date = Date.strptime("1972-08-31", "%Y-%m-%d")
puts another_date.day
=> 31
```
