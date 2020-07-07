# XML-training

Some ideas for getting dirt on your hands with XML, to be performed in this order:

## Installation

1. install xmllint, xsltproc, xmlcatalog
   (standard C utilities from you package manager) 
   - 'brew install xmlstartlet'
1. install Java SDK, for eks openjdk-11-jdk 
   - 'brew tap AdoptOpenJDK/openjdk'
   - 'brew cask install adoptopenjdk11' 

1. install JRuby 
   - rbenv install jruby-X.X.X.X 
   - As of writing the latest version with rbenv is 9.2.11.1 and according to Jruby.org jruby-9.1.17.0 is the latest stable version.

1. Dependencies
   -  Install a few necessary dependencies with Gem
   -  'gem install bundle' 
   -  'bundle install'
   -  'bundle update' (I had to do an additional specific update of rake, with 'bundle update rake' to get the bin/ci-test-stylesheets.sh running, but experience varies.)

## Karnov XML handling

1. Git clone ns-karnovgroup-com
1. see 'spec/testdata/ilse/dk/' for some test data
   ( or other spec/testdata/ dirs )

1. run test suite
      - bin/ci-test-schemas.sh
      - bin/ci-test-stylesheets.sh

1. Figure out how catalog lookups work using xmlcatalog
   (against catalog ns.karnovgroup.com/catalog-utf-8.xml)
   using various public and system identifiers taken from
   DK test data above. Remember to set the environment variable XML_CATALOG_FILES to {your projects path}/cns-karnovgroup-com/ns.karnovgroup.com/catalog-utf-8.xml

1. Write an xmllint CLI command that DTD validates one of the above
   DK documents (against catalog ns.karnovgroup.com/catalog-utf-8.xml).
   Inspect the DTD which is used by catalog lookup just to get an idea
   how they look like and are made.
   
1. Write an XSLT-template and xsltproc CLI command that transforms a DK doc from latin-1 to UTF-8

1. Write an xsltproc CLI command that transforms a DK document into HTML
   rendering, use stylesheet
   ns.karnovgroup.com/stylesheets/ft/html/karnov.xsl
   inspect html with browser, find same document in Pro Classic or JUNO,
   compare

1. Git clone xml-toolbox

   a) inspect vendor dir for third party tools, especially saxon
      inspect bash wrappers for these tools

   b) make sure that JRuby installation works
      run test suite

   c) repeat a) - b), now with JAVA Saxon tools 

   d)  Write an saxon9 CLI command that transforms above UTF-8 DK       document
   back to latin-1 using XSLT 2.0 stylesheet
   ns.karnovgroup.com/stylesheets/common/util/utf-8_to_iso-8859-1.xsl


## DATA
1. Get access to ILSE TEST
   DK http://cphlin01.tlrs.nu/pls/ilseweb/ilseweb.login
   SE http://cphlin01.tlrs.nu/pls/ilseweb_se/ilseweb.login
   fetch some smaller documents

## OXYGEN

1. Git clone xml-editors

   a) Make sure that the editor is set up correctly using
      oxygenxml/Karnov.xpr

   b) Open above DK test docs in Oxyen and 

   c) Repeat from within Oxygen 