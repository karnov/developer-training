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



### 1\. Code style checker

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

### Configuring rubocop

Rubocop comes with default settings, that are useful and meaningful, such as `Metrics/LineLength` which will ask you to make your code lines only 80 characters.

But in some projects you may struggle with that limitation. In such case you can make rubocop accept lines beyond 100 characters, using a `.rubocop.yml` file in the root of the software project.

```
Metrics/LineLength:
  Max: 100
```

As we saw before, Rubocop can 

```
Layout/AlignHash:
  Enabled: true
  EnforcedHashRocketStyle: table
  EnforcedColonStyle: table
```

In the same way `Metrics/LineLength` will 

