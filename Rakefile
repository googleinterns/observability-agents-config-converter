# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'

desc 'Run Rubocop for style violations'
RuboCop::RakeTask.new

desc 'Run Tests'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test' << 'data'
  test.test_files = ['test/test_config_parser.rb']
end

task default: %i[rubocop test]
