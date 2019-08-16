beer = "øl"
puts beer.encoding
puts beer.bytes.inspect

latin_beer = "øl".encode("iso8859-1")
puts latin_beer.encoding                                      # => #<Encoding:ISO-8859-1>
puts latin_beer.bytes.inspect

fallback = {
  "é" => "&eacute;"
}
puts "Napoléon".encode("ascii", fallback: fallback)

puts "Göteborg".upcase
