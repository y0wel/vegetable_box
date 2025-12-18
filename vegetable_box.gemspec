# frozen_string_literal: true

require_relative 'lib/vegetable_box/version'

Gem::Specification.new do |spec|
  spec.name = 'vegetable_box'
  spec.version = VegetableBox::VERSION
  spec.authors = ['y0wel']
  spec.email = ['yowel@web.de']

  spec.summary = <<-SUMMARY
    A ruby gem that checks the current order cart for https://www.diegemuesekiste.de. Can be used for grocery lists etc.
  SUMMARY

  spec.homepage = 'https://github.com/y0wel/vegetable_box'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/y0wel/vegetable_box'
  spec.metadata['changelog_uri'] = "https://github.com/y0wel/vegetable_box'/releases/tag/v#{spec.version}"
  spec.metadata['bug_tracker_uri'] = 'https://github.com/y0wel/vegetable_box/issues'

  spec.require_paths = ['lib']
end
