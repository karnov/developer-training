# Coding style

First of all, Ruby syntax is not as verbose as many other programming languages. That means that, it is actually possible to understand the functionality of the code without much documentation added.

In fact it is better to use self-explaining classes, method, variable names, error classes, etc. such as

```ruby
DATE_REGEX = ...

def parse_date
...
end

def publication_date
  parse_date(...)
end

...

decision_dates = \
  law_document
    .related_caselaw_documents
    .map do |case_law_document|
      case_law_document.decision_date
    end
```

etc.

## Rubocop

Running `rubocop` with no arguments will check all Ruby source files in the current directory:

```bash
$ rubocop
```

Alternatively you can pass `rubocop` a list of files and directories to check:

```bash
$ rubocop app spec lib/something.rb    
```

Create a file named `bad_style.rb` with the following

```ruby
def badName
  if something
    test
    end
end
```

Running rubocop on it would produce the following report:

```
$ rubocop bad_style.rb
Inspecting 1 file
W

Offenses:

bad_style.rb:1:1: C: Style/FrozenStringLiteralComment: Missing magic comment # frozen_string_literal: true.
def badName
^
bad_style.rb:1:5: C: Naming/MethodName: Use snake_case for method names.
def badName
    ^^^^^^^
bad_style.rb:2:3: C: Style/GuardClause: Use a guard clause instead of wrapping the code inside a conditional expression.
  if something
  ^^
bad_style.rb:2:3: C: Style/IfUnlessModifier: Favor modifier if usage when having a single-line body. Another good alternative is the usage of control flow &&/||.
  if something
  ^^
bad_style.rb:4:5: W: Layout/EndAlignment: end at 4, 4 is not aligned with if at 2, 2.
    end
    ^^^
bad_style.rb:5:4: C: Layout/TrailingBlankLines: Final newline missing.
end
   

1 file inspected, 6 offenses detected
```

### Auto-correcting offenses

You can also run rubocop in an auto-correct mode (`-a`), where it will try to automatically fix the problems it found in your code. Try it on the file you created before

```
$ rubocop -a bad_style.rb
Inspecting 1 file
C

Offenses:

bad_style.rb:1:1: C: [Corrected] Style/FrozenStringLiteralComment: Missing magic comment # frozen_string_literal: true.
def badName
^
bad_style.rb:2:3: C: [Corrected] Style/IfUnlessModifier: Favor modifier if usage when having a single-line body. Another good alternative is the usage of control flow &&/||.
  if something
  ^^
bad_style.rb:3:5: C: Naming/MethodName: Use snake_case for method names.
def badName
    ^^^^^^^
bad_style.rb:5:4: C: [Corrected] Layout/TrailingBlankLines: Final newline missing.
end
   

1 file inspected, 4 offenses detected, 3 offenses corrected
```

So rubocop helped us fix 3 of 4 offenses - I like it!

For that reason, it is quite useful to have Rubocop autocorrection available wihtin your editor.

### Customizing rubocop for your project

Rubocop comes with default settings, that are useful and meaningful, such as `Metrics/LineLength` which will ask you to make your code lines only 80 characters.

But in some projects you may struggle with that limitation. In such case you can make rubocop accept lines beyond 100 characters, using a `.rubocop.yml` file in the root of the software project.

```
Metrics/LineLength:
  Max: 100
```

As we saw before, rubocop (`-a`) auto-corrections can save you a lot of time, styling your code.

Say we want our `Hash` objects rendered in `table` style, we should add the below to `.rubocop.yml`

```
Layout/AlignHash:
  Enabled: true
  EnforcedHashRocketStyle: table
  EnforcedColonStyle: table
```

and run `rubocop -a` again on your file

### Pragmatic use of rubocop

If only a few file in your project, fails have long lines, i.e. `Metrics/LineLength` offenses, then there's no point allowing other files to be harmed by a loose `Metrics/LineLength` setting.

In such case you should exclude the given file from `Metrics/LineLength`, i.e.

```
Metrics/LineLength:
  Exclude:
    - 'path/to/file_with_long_lines.rb'
```

If there's an issue in a few lines, you can even deactivate rubocop for those

```ruby
letters = %w[a b]

# rubocop:disable Metrics/LineLength
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50]
# rubocop:enable Metrics/LineLength

puts letters
puts numbers
```