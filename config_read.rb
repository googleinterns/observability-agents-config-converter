# frozen_string_literal: true

$LOAD_PATH.push('../fluentd/lib')

require 'fluent/config/v1_parser'

def read_elements(ele_obj, depth)
  # displays name, attributes, elements of each element in config file
  blank = ' ' * depth
  # NAME
  puts "#{blank}name : #{ele_obj.name}"
  # ATTRIBUTES
  not_empty = false
  ele_obj.each do |a|
    puts "#{blank}attr #{a[0]} : #{a[1]}"
    not_empty = true
  end
  puts "#{blank}(no attributes)" unless not_empty
  # ELEMENTS
  ele_obj.elements.each do |e|
    puts "#{blank}element :"
    # recursive call to display nested elements
    read_elements(e, depth + 4)
  end
end

while true
  puts 'Enter the file\'s path'
  path = gets.chomp
  break if File.exist?(path) && (File.extname(path) == '.conf')

  puts 'Invalid file! Try again!'
end

file_str = File.read(path)
file_name = File.basename(path)
file_dir = File.dirname(path)
file_parse = Fluent::Config::V1Parser.parse(file_str, file_name, file_dir, Kernel.binding)
read_elements(file_parse, 0)
