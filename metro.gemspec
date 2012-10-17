# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'misfits/version'

Gem::Specification.new do |gem|
  gem.name          = "misfits"
  gem.version       = Metro::VERSION
  gem.authors       = ["Franklin Webber"]
  gem.email         = ["franklin.webber@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""
  
  gem.add_dependency 'gosu', '~> 0.7'
  
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
