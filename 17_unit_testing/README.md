# Unit testing

## Why should you write tests?

Here’s why:

### It builds a safety net against errors (especially useful for refactoring)

If you don’t have a test suite then you don’t want to touch your code, because of the fear of something breaking…

…having tests increases your confidence!

### It helps document your code

Your tests describe what your application should be doing.

### It gives you a feedback loop

When you are doing test driven development ([TDD[(https://en.wikipedia.org/wiki/Test-driven_development)]) **you get a feedback loop** that tells you what to focus on next, useful if you get distracted easily.

### It helps you make sure your code is producing the results you expect

This one is important!

If you are writing some complex logic, then **you want to make sure it’s working with many different inputs** and not just with one example you came up with.

Tests can help you uncover corner cases and **document them**.

## Testdriven development in RSpec

In Karnov, RSpec is the preferred testing framework, so that will be the topic of this lesson on unit testing.

To understand how test driven development and RSpec works let’s write a simple application that finds [factorial numbers](https://en.wikipedia.org/wiki/Factorial), e.g. `3! = 3 * 2 * 1 = 6`

And let us approach it test driven, i.e. we will

1. **write the test**,
2. **run all tests** and see if the new test fails
3. **write the code** that that causes the tests to pass
4. **run tests** (we can be confident that the new code meets the test requirements)
5. **refactor code**, i.e. cleanup/improve code for readability and maintainability

**Repeat** with another test

### 1. Writing the test

There's a naming convention in RSpec, that test file for the class `Factorial` are named `factorial_spec.rb`. Thus, let's create a file with the following

```ruby
require 'rspec'

describe Factorial do
  # ...
end
```

This is the initial code for writing your first **RSpec** test.

You need to require the [rspec gem](https://github.com/rspec/rspec).

Then you need to create a `describe` block to **group all your tests for the Factorial class together**.

Next is the `it` block:

```ruby
require 'rspec'

describe Factorial do
  it "finds the factorial of 5" do
    calculator = Factorial.new

    expect(calculator.factorial_of(5)).to eq(120)
  end
end
```

This is the test name, plus a way to group together all the **components** of the test itself.

The components are:

-   Setup
-   Exercise
-   Verify

The setup is where you **create any objects** that you need to create.

Then you call the method you want to exercise to get its return value.

Finally, you **verify the result with an expectation** (also known as an assertion in other testing frameworks). Here we did some hand calculation to find that `5! = 5 * 4 * 3 * 2 * 1 = 120`.

### 2. Run all tests

When running the tests

```bash
$ rspec .
F

Failures:

An error occurred while loading ./factorial_spec.rb.
Failure/Error:
  describe Factorial do
    it "finds the factorial of 5" do
      calculator = Factorial.new

      expect(calculator.factorial_of(5)).to eq(120)
    end
  end

NameError:
  uninitialized constant Factorial
# ./factorial_spec.rb:3:in `<top (required)>'
```

That's expected because we don’t have a `Factorial` class yet - so let’s create a new file `factorial.rb` and require it from within `factorial_spec.rb`

```ruby
class Factorial
end
```

and

```ruby
require 'rspec'
require './factorial'

describe Factorial do
  it "finds the factorial of 5" do
    calculator = Factorial.new

    expect(calculator.factorial_of(5)).to eq(120)
  end
end
```

...and rerun

Next error will be

```bash
F

Failures:

  1) Factorial finds the factorial of 5
     Failure/Error: expect(calculator.factorial_of(5)).to eq(120)

     NoMethodError:
       undefined method `factorial_of' for #<Factorial:0x00007fcab89fa878>
     # ./factorial_spec.rb:8:in `block (2 levels) in <top (required)>'
...
```

We'll fix this by creating the `factorial_of` method

```ruby
class Factorial
  def factorial_of
  end
end
```

Then run the test again

```bash
F

Failures:

  1) Factorial finds the factorial of 5
     Failure/Error: expect(calculator.factorial_of(5)).to eq(120)

     ArgumentError:
       wrong number of arguments (given 1, expected 0)
     # ./factorial.rb:2:in `factorial_of'
     # ./factorial_spec.rb:8:in `block (2 levels) in <top (required)>'
...
```

Errors are not something to be frustrated with. They are feedback.

Now, add one method argument to the `factorial_of` method

```ruby
class Factorial
  def factorial_of(number)
  end
end
```

What we get now is **a test failure**

```bash
F

Failures:

  1) Factorial finds the factorial of 5
     Failure/Error: expect(calculator.factorial_of(5)).to eq(120)

       expected: 120
            got: nil

       (compared using ==)
     # ./factorial_spec.rb:8:in `block (2 levels) in <top (required)>'
```

This is exactly where we want to be at this point!

The next task is to implement the method

```ruby
class Factorial
  def factorial_of(n)
    (1..n).inject(:*)
  end
end
```

... and we’ll get our **first passing test**

```bash
.

Finished in 0.00709 seconds (files took 0.20382 seconds to load)
1 example, 0 failures
```

This is what we call test-driven development (TDD).

## RSpec `let` and `subject`

If you want to write many tests and **reuse the same objects** you can define these objects with `let` statements.

For instance you can reuse `calculator` in all your tests under the same `describe` block.

```ruby
describe Factorial do
  let(:calculator) { Factorial.new }

  it "finds the factorial of 5" do
    expect(calculator.factorial_of(5)).to eq(120)
  end

  it "finds the factorial of 3" do
    expect(calculator.factorial_of(3)).to eq(6)
  end
end
```

Another version of `let` is `subject`.

The only difference is that you can only have one `subject`, and it’s meant to be **an instance** of the main object you are testing.

In fact RSpec already creates a default `subject` which is
`subject { Factorial.new }`

This is called the "implicit subject". And you can use it in your test

```ruby
describe Factorial do
  it "finds the factorial of 5" do
    expect(subject.factorial_of(5)).to eq(120)
  end
end
```

or you can give your subject a name, like `calculator`,

```ruby
describe Factorial do
  subject(:calculator) { Factorial.new }
  it "finds the factorial of 5" do
    expect(subject.factorial_of(5)).to eq(120)
  end
end
```

## Running code before your tests

RSpec has execution hooks you can use to run something before and after every test, or a whole group of tests. For example

```ruby
describe Shop do
  before(:all) { Shop.prepare_database }
  after (:all) { Shop.cleanup_database }
end
```

If you want to run this code for each example (example = test in RSpec) you can use `:each` instead of `:all`.

## More on grouping tests

If you’re testing different scenarios in your app then it may be helpful to group related tests together.

You can do this using a **context block** in RSpec.

Here’s an example

```ruby
describe Course do
  context "when user is logged in" do
    it "displays the course lessons" do
    end

    it "displays the course description" do
    end
  end

  context "when user it NOT logged in" do
    it "redirects to login page" do
    end

    it "it shows a message" do
    end
  end
end
```

## RSpec expectations and matchers

You may remember this example we have been using

```ruby
expect(calculator.factorial_of(5)).to eq(120)
```

But what is this `eq(120)` part?

Well, 120 is the value we are expecting…

…and `eq` is what we call a matcher.

Matchers are how RSpec compares the **output of your method** with your **expected value**.

In the case of `eq`, RSpec uses the `==` (equality) operator .

But **there are other matchers** you can use.

```ruby
expect(nil).to be_nil

expect([1,2,3]).to include([3])

expect{ text.count }.to raise_error(NoMethodError)

expect{ stock.increment }.to change(stock, :value).by(100)
```

You can read more about the [built-in matchers](https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers) or built your own [custom matcher](https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/custom-matchers/define-a-custom-matcher)

## RSpec Formatters

The default RSpec output is in the “progress” format.

With this format you see dots (`.`) representing 1 passing test each, an `F` for a failed test (expected & actual don’t match), or an `E` for an error.

Alternative formatting options are

-   progress
-   documentation
-   json
-   html

You can enable them with the -f flag:

```bash
$ rspec . -f d

Factorial
  finds the factorial of 5
...
```

## Exercise

Try to cover the `Person` class with Rspec tests.

## Exercise (advanced)

Create tests for the `BankAccount` class.

Tip: In order to test the `BankAccount` properly, you have to mock the `Person` class. But that's another topic, that we will not go through here. Read more on [test doubles](https://www.rubyguides.com/2018/10/rspec-mocks/).
