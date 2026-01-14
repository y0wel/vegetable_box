# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[spec rubocop]

task :console do
  require 'irb'
  require 'irb/completion'
  require 'awesome_print'
  require 'debug'
  require 'vegetable_box'

  def reload!
    original_warn_level = $VERBOSE
    $VERBOSE = nil

    files = $LOADED_FEATURES.grep(%r{/ioki/})

    files.each { |file| load file }
  ensure
    $VERBOSE = original_warn_level
  end

  ARGV.clear
  IRB.start
end

task c: :console
