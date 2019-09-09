# Gems

Sharing and using others is amazingly easy, since there's a built-in package manager distributed with Ruby. Rubygems provides a standard format for distributing Ruby programs and libraries in a self-contained format called a "gem".

The interface for RubyGems is a command-line tool called `gem` which can install and manage libraries (the gems). RubyGems integrates with Ruby run-time loader to help find and load installed gems from standardized library folders. Though it is possible to use a private RubyGems repository, the public repository [rubygems.org](https://rubygems.org/) is most commonly used for gem management.

The public repository helps users find gems, resolve dependencies and install them.

## Installing gems

Let's install the gem `roman-numerals`, but first let us check if it's already available.

Jump into `irb`

```ruby
require 'roman-numerals'
LoadError: cannot load such file -- roman-numerals
...
```

So let's exit and install it


```bash
$ gem install roman-numerals
Fetching roman-numerals-0.3.0.gem
Successfully installed roman-numerals-0.3.0
1 gem installed
```

and jump back into `irb`

```ruby
require 'roman-numerals'
=> true
```

That's magic!

## `require` and the `$LOAD_PATH`

What happens when you write `require 'roman-numerals'` is that Ruby will look in the folders listed in your `$LOAD_PATH` global variable to for a file called `roman-numerals.rb`.

So let's have a look at what's in our `$LOAD_PATH`.

```ruby
puts $LOAD_PATH

~/.rvm/rubies/ruby-2.6.3/lib/ruby/gems/2.6.0/gems/did_you_mean-1.3.0/lib
~/.rvm/gems/ruby-2.6.3/gems/coderay-1.1.2/lib
~/.rvm/gems/ruby-2.6.3/gems/method_source-0.9.2/lib
~/.rvm/gems/ruby-2.6.3/gems/roman-numerals-0.3.0/lib
~/.rvm/rubies/ruby-2.6.3/lib/ruby/site_ruby/2.6.0
~/.rvm/rubies/ruby-2.6.3/lib/ruby/site_ruby/2.6.0/x86_64-darwin18
~/.rvm/rubies/ruby-2.6.3/lib/ruby/site_ruby
~/.rvm/rubies/ruby-2.6.3/lib/ruby/vendor_ruby/2.6.0
~/.rvm/rubies/ruby-2.6.3/lib/ruby/vendor_ruby/2.6.0/x86_64-darwin18
~/.rvm/rubies/ruby-2.6.3/lib/ruby/vendor_ruby
~/.rvm/rubies/ruby-2.6.3/lib/ruby/2.6.0
~/.rvm/rubies/ruby-2.6.3/lib/ruby/2.6.0/x86_64-darwin18
=> nil
```

See let us look in `~/.rvm/gems/ruby-2.6.3/gems/roman-numerals-0.3.0/lib` to see what's there.

```bash
$ ls ~/.rvm/gems/ruby-2.6.3/gems/roman-numerals-0.3.0/lib
roman-numerals.rb
```

There it is.

Now you may wonder, what's in `~/.rvm/rubies/ruby-2.6.3/lib/ruby/2.6.0`

```bash
§ ls ~/.rvm/rubies/ruby-2.6.3/lib/ruby/2.6.0
```

Among a lot of things, you find `irb.rb` and `set.rb` - we have used these earlier. So we are probably looking into Ruby's standard library.

So let's say, that we wan't to be able to require our files in the `lib` folder in our current project, then we have to add that `lib` folder to `$LOAD_PATH`

Another detail about `require` is that it will make sure, that the file is only loaded once, which is good, since you can add the `require` in all files that needs the dependency.

But if you really need to reload the file, then use `load './bank_account.rb'`.

## Exercise

Try put your files `bank_account.rb` and `person.rb` in a `lib` folder and add that to `$LOAD_PATH`

## Gem structure

If you wan't to build and distribute your own gem, it's advised that you structure the folder, so that all source code goes into `lib`, tests (if any) into `spec`. Let's take `roman-numerals` as example:

```bash
$ tree ~/.rvm/gems/ruby-2.6.3/gems/roman-numerals-0.3.0
...
├── roman-numerals.gemspec
├── lib
│   └── roman-numerals.rb
└── spec
    ├── spec_helper.rb
    └── roman-numerals_spec.rb
```

(I intentionally left out some files)

As mentioned before, it's advised that the name of the gem is the same as the name of the .rb file in `lib`. Also you should namespace your code with the name of the `gem`. Let's look inside `roman-numerals.rb``

```bash
$cat ~/.rvm/gems/ruby-2.6.3/gems/roman-numerals-0.3.0/lib/roman-numerals.rb
```
```ruby
module RomanNumerals
  @base_digits = {
    1    => 'I',
    4    => 'IV',
    5    => 'V',
    9    => 'IX',
    10   => 'X',
    40   => 'XL',
    50   => 'L',
    90   => 'XC',
    100  => 'C',
    400  => 'CD',
    500  => 'D',
    900  => 'CM',
    1000 => 'M'
  }

  def self.to_roman(value)
    result = ''
    @base_digits.keys.reverse.each do |decimal|
      while value >= decimal
        value -= decimal
        result += @base_digits[decimal]
      end
    end
    result
  end

  def self.to_decimal(value)
    value.upcase!
    result = 0
    @base_digits.values.reverse.each do |roman|
      while value.start_with? roman
        value = value.slice(roman.length, value.length)
        result += @base_digits.key roman
      end
    end
    result
  end
end
```

See, all code is in the `RomanNumerals` namespace - nothing unexpected here.

Btw, `roman-numerals` (which I more or less randomly picked) is a fine example of how a few lines of error-free code, can be a good candidate for a `gem`. It's in fact better to create many small and focused gems rather than one-does-everything gem.

## The `gemspec`

The gemspec is where you tell how `gem build` should build your gem and how `gem install` should install it on someones computer. So it specifies the list of files that should go into the gem, the gem name, the version, the license, the author, runtime and development dependencies, so these will be installed together with the gem on `gem install`.

## Version

So let's imagine that I used `roman-numerals` in two different projects.

The other project uses version 0.0.2, the current uses 0.0.3.
Try install both and run `gem list`.

There's no way `require` knows which one you prefer. It picks the latest.

But there may be breaking changes between the two versions.

That's where Bundler comes in.
