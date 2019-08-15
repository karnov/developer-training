# Ruby scripts

Ruby is an [interpreted](https://en.wikipedia.org/wiki/Interpreted_language) language

## Exercise

Make a file `script.rb` containing

```ruby
puts "Hello world"
```

and run it using the interpreter

```bash
$ ruby script.rb
  "Hello world"
```

## Exercise - executable

On Unix like systems a file can be turned into an executable by adding a [`!#`](https://en.wikipedia.org/wiki/Shebang_(Unix)) followed by the path to the interpreter

Create another file, `executable-script.rb` with the following

```ruby
#!/usr/bin/env ruby
puts "Hello world"
```

and giving execution rights (`+x`) to the owner (`u`) of the file

```bash
$ chmod u+x executable-script.rb
```

Now run it with

```bash
$ ./executable-script.rb
  "Hello world"
```

It also works without the `.rb` extension - so try rename it

```bash
$ mv executable-script.rb executable-script

$ ./executable-script
  "Hello world"
```

