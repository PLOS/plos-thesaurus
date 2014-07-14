require 'xmlsimple'
require 'pry'

xml_data = File.open('plosthes.2014-2.extract.xml', 'r')
data = XmlSimple.xml_in(xml_data)

# We want a nested JSON structure from this XML
# binding.pry
# First find all top level terms (that don't have a BT key)

top_level_terms = Hash.new

data['TermInfo'].each do |term|
  # Has nested terms, is therefore a parent key
  if term.has_key?('NT')
    nested = term['T']
    puts nested
  end
end

def has_nested_terms(hash)
  true
end