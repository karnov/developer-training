# Strings

### Creating strings

```ruby
single_line = "Hälsingegatan 43, 113 82 Stockholm"
puts single_line

multiple_lines = "Hälsingegatan 43,"\
  "113 82 Stockholm"
puts single_line

string_literals = %q(
  Hälsingegatan 43,
  113 82 Stockholm
)
puts string_literals

heredoc = <<~XML
  <address>
    <street>Hälsingegatan 43</street>
    <zip>113 82</zip>
    <city>Stockholm</city>
  </address>
XML
puts heredoc
```

## Strings are (unfortunately) mutable

```ruby
text = "here"
text[2] = " is over ther"
text
=> "he is over there"
```

## String encoding

Strings are UTF-8 by default, but other encodings are well supported

```ruby
beer = "øl"
beer.encoding
=> Encoding::UTF_8
beer.bytes
=> [195, 184, 108]

latin_beer = "øl".encode("iso8859-1")
latin_beer.encoding                                      # => #<Encoding:ISO-8859-1>
latin_beer.bytes
=> [248, 108]
```

Changing encoding to e.g. `ASCII` is easy

```ruby
"Napoléon".encode("ascii")
Encoding::UndefinedConversionError: U+00E9 from UTF-8 to US-ASCII
```

... but you of course need to do something about the Unicode codepoints that aren't part of the `ASCII` character set.

```ruby
fallback = {
  "é" => "&eacute;"
}
"Napoléon".encode("ascii", fallback: fallback)
```

Most string functions are utf-8 compatible,

```ruby
"Göteborg".upcase
=> "GÖTEBORG"
```

but be aware when using old ruby versions. E.g. when running the above in ruby 2.2 we get an unexpected result.

```ruby
ruby-2.2.10> "Göteborg".upcase
=> "GöTEBORG"
```

