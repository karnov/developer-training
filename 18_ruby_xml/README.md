# XML

In Ruby the only real option is the `nokogiri` gem, which essentially just wraps the [libxml](http://www.xmlsoft.org/) C library.

Reading a XML string into a DOM

```ruby
require 'nokogiri'

document = Nokogiri::XML <<~XML
  <?xml version="1.0" encoding="UTF-8"?>
  <menu>
    <meal>
      <name>Belgian Waffles</name>
      <price>$5.95</price>
      <description>Two of our famous Belgian Waffles with plenty of real maple syrup</description>
      <calories>650</calories>
    </meal>
    <meal>
      <name>French Toast</name>
      <price>$4.50</price>
      <description>Thick slices made from our homemade sourdough bread</description>
      <calories>600</calories>
    </meal>
    <meal>
      <name>Homestyle Breakfast</name>
      <price>$6.95</price>
      <description>Two eggs, bacon or sausage, toast, and our ever-popular hash browns</description>
      <calories>950</calories>
    </meal>
  </menu>
XML
```

Then we can use css selectors as well as XPaths, e.g. the meal listed first:
```ruby
document.at_xpath("//meal")
=> #(Element:0x3fd6e4481674 {
  name = "meal",
  children = [
    #(Text "\n    "),
    #(Element:0x3fd6e451f16c { name = "name", children = [ #(Text "Belgian Waffles")] }),
    #(Text "\n    "),
    #(Element:0x3fd6e45201c0 { name = "price", children = [ #(Text "$5.95")] }),
    #(Text "\n    "),
    #(Element:0x3fd6e453dcfc { name = "description", children = [ #(Text "Two of our famous Belgian Waffles with plenty of real maple syrup")] }),
    #(Text "\n    "),
    #(Element:0x3fd6e4541230 { name = "calories", children = [ #(Text "650")] }),
    #(Text "\n  ")]
  })
```

and all names of meals:

```ruby
document.xpath("//meal/name")
=> [#<Nokogiri::XML::Element:0x3fd6e451f16c name="name" children=[#<Nokogiri::XML::Text:0x3fd6e452f260 "Belgian Waffles">]>, #<Nokogiri::XML::Element:0x3fd6e4550244 name="name" children=[#<Nokogiri::XML::Text:0x3fd6e4554b28 "French Toast">]>, #<Nokogiri::XML::Element:0x3fd6e4580750 name="name" children=[#<Nokogiri::XML::Text:0x3fd6e4585048 "Homestyle Breakfast">]>]
```

## XSLT

We can apply a stylesheet

```ruby
stylesheet = Nokogiri::XSLT <<~XML
  <?xml version="1.0" encoding="UTF-8"?>
  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    version="1.0">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
      <html>
        <body>
          <xsl:apply-templates />
        </body>
      </html>
    </xsl:template>

    <xsl:template match="meal">
      <div class="card">
        <xsl:apply-templates />
      </div>
    </xsl:template>

    <xsl:template match="meal/name">
      <h1><xsl:apply-templates /></h1>
    </xsl:template>

    <xsl:template match="meal/price">
      <p class="price"><xsl:apply-templates /></p>
    </xsl:template>

    <xsl:template match="meal/description">
      <p><xsl:apply-templates /></p>
    </xsl:template>

    <xsl:template match="calories"/>
  </xsl:stylesheet>
XML

stylesheet.apply_to(document)
=>
<html xmlns="http://www.w3.org/1999/xhtml">
  <body>
    <div class="card">
      <h1>Belgian Waffles</h1>
      <p class="price">$5.95</p>
      <p>Two of our famous Belgian Waffles with plenty of real maple syrup</p>

    </div>
    <div class="card">
      <h1>French Toast</h1>
      <p class="price">$4.50</p>
      <p>Thick slices made from our homemade sourdough bread</p>

    </div>
    <div class="card">
      <h1>Homestyle Breakfast</h1>
      <p class="price">$6.95</p>
      <p>Two eggs, bacon or sausage, toast, and our ever-popular hash browns</p>

    </div>
  </body>
</html>
```

## Exercise

The below fetches a danish "bekendtgørelse" in LexDania XML from retsinformation.dk.

Try create a stylesheet that renders it into HTML.

```ruby
require 'open-uri'

document = Nokogiri::XML(open("https://www.retsinformation.dk/eli/lta/2019/1040/xml"))
```