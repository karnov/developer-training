# XML

In Ruby the only real option is the `nokogiri` gem, which essentially just wraps the [libxml](http://www.xmlsoft.org/) C library.

## Parseing XML into a DOM

```ruby
require 'nokogiri'

document = Nokogiri::XML <<~XML.strip
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
    #(Element:0x3fd6e45201c0 { name = "price", children = [ #(Text "5.95")] }),
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

## DOM manipulation

Nokogiri has a really nice API for manipulating the DOM. E.g. let's say we add another meal.

```ruby
last_meal = document.xpath("//meal").last
last_meal.add_next_sibling <<~XML.strip
  <meal>
    <name>Hashbrown potatoes</name>
    <price>2.95</price>
    <description>Our ever-popular hash browns</description>
  </meal>
XML

document.to_xml
=>
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
  <meal>
    <name>Hashbrown potatoes</name>
    <price>2.95</price>
    <description>Our ever-popular hash browns</description>
  </meal>
</menu>
```

or decrease prices by 10%

```ruby
document.xpath("//meal/price").each do |price_node|
  price_node.content = (price_node.text.to_f * 1.1).round(2).to_s
end

document.to_xml
=>
<?xml version="1.0" encoding="UTF-8"?>
<menu>
  <meal>
    <name>Belgian Waffles</name>
    <price>6.55</price>
    <description>Two of our famous Belgian Waffles with plenty of real maple syrup</description>
    <calories>650</calories>
  </meal>
  <meal>
    <name>French Toast</name>
    <price>4.95</price>
    <description>Thick slices made from our homemade sourdough bread</description>
    <calories>600</calories>
  </meal>
  <meal>
    <name>Homestyle Breakfast</name>
    <price>7.65</price>
    <description>Two eggs, bacon or sausage, toast, and our ever-popular hash browns</description>
    <calories>950</calories>
  </meal>
  <meal>
    <name>Hashbrown potatoes</name>
    <price>3.25</price>
    <description>Our ever-popular hash browns</description>
  </meal>
</menu>
```

## XSLT

A (IMO) far better approach for transforming XML is using XSLT. One main difference is,
that DOM manipulation is done on the document itself, whereas XSLT is creating a **new** document
based on the input.

Simplified, there's two kind of problems in XML transformation:
- one is where you change a small detail, but keep the format, e.g. like before, change the prices.
- the other is where you return the document in another format (i.e. content model), e.g. when
 rendering a Karnov law document into HTML, to be displayable on a browser.

### The identity transform

Let's change the prices with a stylesheet. It's almost an identity transform, i.e. that every
node and attribute will be copied. ...with one exception, the price.

```ruby
stylesheet = Nokogiri::XSLT <<~XML
  <?xml version="1.0" encoding="UTF-8"?>
  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    version="1.0">

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
```

### The "full" transform

A good example is, when we wan't to render our menu XML in a browser.
Then we need HTML, and we can use the following stylesheet to do that:

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
      <p class="price">5.95</p>
      <p>Two of our famous Belgian Waffles with plenty of real maple syrup</p>

    </div>
    <div class="card">
      <h1>French Toast</h1>
      <p class="price">4.50</p>
      <p>Thick slices made from our homemade sourdough bread</p>

    </div>
    <div class="card">
      <h1>Homestyle Breakfast</h1>
      <p class="price">6.95</p>
      <p>Two eggs, bacon or sausage, toast, and our ever-popular hash browns</p>

    </div>
  </body>
</html>
```

## (Long) exercise

The below fetches a danish "bekendtgørelse" in LexDania XML from retsinformation.dk.

Try create a stylesheet that renders it into HTML.

```ruby
require 'open-uri'

document = Nokogiri::XML(open("https://www.retsinformation.dk/eli/lta/2019/1040/xml"))
```

## DTD validation

DTD validation is done when parsing, hence
