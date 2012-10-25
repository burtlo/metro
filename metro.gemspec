# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metro/version'

Gem::Specification.new do |gem|
  gem.name          = "metro"
  gem.version       = Metro::VERSION
  gem.authors       = ["Franklin Webber"]
  gem.email         = Metro::CONTACT_EMAILS

  gem.summary       = <<-EOS
    Metro is a 2D Gaming framework built around gosu (game development library).
    Metro makes it easy to create games by enforcing common conceptual structures
    and conventions.
  EOS
  gem.description   = gem.summary

  gem.homepage      = Metro::WEBSITE

  gem.add_dependency 'gosu', '~> 0.7'
  gem.add_dependency 'sender', '~> 1.5.10'
  gem.add_development_dependency 'rspec', '~> 2.11'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
