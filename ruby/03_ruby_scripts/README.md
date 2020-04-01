# Ruby scripts



## Exercise - a script file

Make a new project `~/src/`, launch yo file `script.rb` containing

```ruby
puts "Hello world"
```

and run it using the interpreter

```bash
$ ruby script.rb
Hello world
```

## Exercise - executable

On Unix like systems a file can be turned into an executable by adding a [`!#`](https://en.wikipedia.org/wiki/Shebang_(Unix)) followed by the path to the interpreter.

It even works without the `.rb` extension - so try rename it

```bash
$ mv executable-script.rb executable-script
```
add the she-bang line in first line

```ruby
#!/usr/bin/env ruby
puts "Hello world"
```

and give it execution rights (`+x`) to the owner (`u`) of the file

```bash
$ chmod u+x executable-script
```

Confirm that it has become executable (`x`)

```bash
$ ls -la 03_ruby_scripts 
total 32
drwxr-xr-x  6 (...)  192 15 Aug 15:04 .
drwxr-xr-x  8 (...)  256 15 Aug 15:34 ..
-rw-r--r--  1 (...)  915 15 Aug 15:03 README.md
-rwxr-xr-x  1 (...)   39 15 Aug 15:04 executable-script
-rw-r--r--  1 (...)   18 15 Aug 14:39 script.rb
```

Now run it

```bash
$ ./executable-script
Hello world
```