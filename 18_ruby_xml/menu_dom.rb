require 'nokogiri'

def document
  @document ||= Nokogiri::XML <<~XML.strip
    <?xml version="1.0" encoding="UTF-8"?>
    <menu>
      <meal>
        <name>Belgian Waffles</name>
        <price>5.95</price>
        <description>Two of our famous Belgian Waffles with plenty of real maple syrup</description>
        <calories>650</calories>
      </meal>
      <meal>
        <name>French Toast</name>
        <price>4.50</price>
        <description>Thick slices made from our homemade sourdough bread</description>
        <calories>600</calories>
      </meal>
      <meal>
        <name>Homestyle Breakfast</name>
        <price>6.95</price>
        <description>Two eggs, bacon or sausage, toast, and our ever-popular hash browns</description>
        <calories>950</calories>
      </meal>
    </menu>
  XML
end

require 'pry'; Pry.start
