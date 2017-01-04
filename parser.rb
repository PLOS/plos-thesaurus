require 'xmlsimple'
require 'json'
require 'pry'

xml_filename = 'plosthes.2014-3.extract.xml'
xml_data = File.open(xml_filename, 'r')
data = XmlSimple.xml_in(xml_data)

base_filename = File.basename(xml_filename, '.*')

# We want a list of string paths for fast lookups
# First find all top level terms (that don't have a BT key)

class Entry
  attr_accessor :xmls, :parents, :children, :name, :synonyms, :bt_key, :nt_key, :rt_key

  def initialize(hash)
    @xmls = hash
    @bt_key = nil
    @nt_key = nil
    @synonyms = nil
    parse(hash)
    @parents = []
    @children = []
  end

  DATA = []

  def ancestors
    return enum_for(:ancestors) unless block_given?

    element = self
    while element
      yield element
      element = element.parent
    end
  end

  def parent
    parents.first
  end

  def self.find_by_name(name)
    DATA.select { |e| e.name == name}
  end

  def self.find_children_for(entry)
    returned = []
    DATA.each do |e|
      next unless e.has_parent?
      if e.bt_key.include?(entry.name)
        returned << e
      end
    end
    returned
  end

  def self.assign_children
    count = 0
    total = DATA.count
    puts "Assigning parents for #{total} entries"
    DATA.each do |entry|
      count += 1
      # Find children for current entry
      children = self.find_children_for(entry)

      # Set current entry as parent of children
      if children.any?
        children.each { |child| child.parents << entry }
      end

      # Set children for current entry
      entry.children = children

      puts "#{count}/#{total}" if count % 100 == 0
    end
  end

  def parse(incoming)
    @name = incoming['T'].first
    @synonyms = incoming['Synonym']
    @bt_key = incoming['BT']
    @nt_key = incoming['NT']
    @rt_key = incoming['RT']
  end

  def has_children?
    return true if nt_key
  end

  def has_parent?
    return true if bt_key
  end

  def self.generate_paths(entry)
    if entry.children.any?
      entry.children.inject([]){|str, child|
        generate_paths(child).each{ |path|
          str += [[entry.name] + path]
        }
        str
      }
    else
      [[entry.name]]
    end
  end
end

top_level_terms = []
bottom_level_terms = []

data['TermInfo'].each do |term|
  # Has nested terms, is therefore a parent key
  entry = Entry.new(term)
  Entry::DATA << entry

  if !entry.has_parent?
    top_level_terms << entry
  end

  if !entry.has_children?
    bottom_level_terms << entry
  end
end

puts "There are #{top_level_terms.count} top-level terms"
puts "There are #{bottom_level_terms.count} base terms"

Entry.assign_children

outfile = File.new("#{base_filename}.txt", 'w')

path_count = 0
top_level_terms.each do |term|
  puts "Exporting #{term.name}"
  Entry.generate_paths(term).each do |path|
    path_count +=1
    outfile.puts(path.join(','))
  end
end

puts "Exported #{path_count} unique term-heirarchies"
outfile.close
