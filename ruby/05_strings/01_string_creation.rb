single_line = "Hälsingegatan 43, 113 82 Stockholm"
puts single_line

multiple_lines = "Hälsingegatan 43,"\
  "113 82 Stockholm"
puts multiple_lines

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