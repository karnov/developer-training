# Ruby irb

Like many other [interpreted](https://en.wikipedia.org/wiki/Interpreted_language) languages, Ruby includes `irb`, an command-line interpreter, that makes it easy to try out some code.

## Exercise

Launch `irb`

```bash
$ irb
```

and add som numbers ... and exit

```ruby
ruby-2.6.3 (main)> puts "Hi"
Hi
 => nil
ruby-2.6.3 (main)> 1 + 2
 => 3
ruby-2.6.3 (main)> exit! 
```

## Debugging code with irb

If you want to debug your code, i.e. the value of a variable `@counter`. You can always write `put @counter`, and 

Say you want to know the value of the variable `@counter` after line 3 in your script 'debugging_with_irb.rb', you can open a `irb` session right there, by adding `binding.irb`.

```ruby
@counter = 1
@counter = @counter + 1
@counter =+ 1
require 'irb'
binding.irb
@counter = 0
```

```bash
$ ruby debugging_with_irb.rb
```

and then check the value of the `@counter` variable

```ruby
ruby-2.6.3 (main)> @counter
=> 1 
```

After that you can either continue `Ctrl+D` until the script exits or you can `exit!` right here

## irb "Intellisense"

When inside a `irb` session, pressing `TAB` will assist you with code completion, listing of methods on an object etc.

## Exercise

Run `debugging_with_irb.rb`

Write `@coun`, press `TAB` too see that it completes into `@counter`

Then write `.`, then press `TAB` again

```ruby
ruby-2.6.3 (main)> @counter.                               ...
@counter.abs
...
@counter.add
...
```

among all the methods on `@counter` we see `.abs` (absolute value) and `.add` (addition)