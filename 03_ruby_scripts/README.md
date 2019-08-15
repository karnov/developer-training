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

Confirm that it has become executable (`x`)

```bash
$ ls -la 03_ruby_scripts 
total 32
drwxr-xr-x  6 u0157312  KARNOVGROUP\Domain Users  192 15 Aug 15:04 .
drwxr-xr-x  8 u0157312  KARNOVGROUP\Domain Users  256 15 Aug 15:34 ..
-rw-r--r--  1 u0157312  KARNOVGROUP\Domain Users  915 15 Aug 15:03 README.md
-rwxr-xr-x  1 u0157312  KARNOVGROUP\Domain Users   39 15 Aug 15:04 executable-script
-rw-r--r--  1 u0157312  KARNOVGROUP\Domain Users   39 15 Aug 15:04 executable-script.rb
-rw-r--r--  1 u0157312  KARNOVGROUP\Domain Users   18 15 Aug 14:39 script.rb
```

Now run it

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

