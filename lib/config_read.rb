# frozen_string_literal: true

$LOAD_PATH.push('fluentd/lib')

require 'fluent/config/v1_parser'
require 'optparse'

# Accepts a file path and prints out parsed version
class ConfigFile
  def initialize(argv = ARGV)
    @argv = argv
    prepare_option_parser
    parse_options
    @file_parse = parse_config
    print_configurations(@file_parse)
  end

  def prepare_option_parser
    @parser = OptionParser.new
    @parser.banner = "\nPrint-Config-File Tool\nUsage: #{$PROGRAM_NAME} " \
      "path/to/file\nOutput: Parsed version of config file"
    @parser.parse!(@argv)
  end

  def usage(message = nil)
    puts @parser.to_s
    puts "\nError: #{message}" if message
  end

  def parse_options
    # parses the arguments, quits program if arguments are invalid
    raise 'Must specify path of file' if @argv.empty?
    raise 'Only one argument is needed' if @argv.size > 1
    raise 'Enter a valid file path' unless File.exist?(@argv[0])
  rescue StandardError => e
    usage(e)
    exit(false)
  end

  def parse_config
    # extracts required information and parses the config file
    file_str = File.read(@argv[0])
    file_name = File.basename(@argv[0])
    file_dir = File.dirname(@argv[0])
    return Fluent::Config::V1Parser.parse(file_str, file_name,
                                                 file_dir, Kernel.binding)
  rescue StandardError => e
    usage(e)
    exit(false)
  end

  def print_configurations(ele_obj, depth = 0)
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
      print_configurations(e, depth + 4)
    end
  end
end

ConfigFile.new
