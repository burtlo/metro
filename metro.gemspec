# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metro/version'

Struct.new("Changes",:date,:changes)

Gem::Specification.new do |gem|
  gem.name          = "metro"
  gem.version       = Metro::VERSION
  gem.authors       = ["Franklin Webber"]
  gem.email         = Metro::CONTACT_EMAILS
  gem.license       = "MIT"
  gem.summary       = <<-EOS
    Metro is a 2D Gaming framework built around gosu (game development library).
    Metro makes it easy to create games by enforcing common conceptual structures
    and conventions.
  EOS
  gem.description   = <<-EOS
    Metro is a 2D Gaming framework built around gosu (game development library).
    Metro makes it easy to create games by enforcing common conceptual structures
    and conventions.
  EOS

  gem.homepage      = Metro::WEBSITE

  gem.add_dependency 'gosu'
  gem.add_dependency 'texplay', '~> 0.4.4.pre'

  gem.add_dependency 'chipmunk'
  gem.add_dependency 'tmx'
  gem.add_dependency 'thor'
  gem.add_dependency 'i18n'
  gem.add_dependency 'activesupport', '~> 4.2'
  gem.add_dependency 'listen'
  gem.add_development_dependency 'rspec', '~> 2.11'
  gem.add_development_dependency 'rspec-its', '~> 1.0.1'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  changes = Metro.changes_for_version(::Metro::VERSION)

  gem.post_install_message = <<-EOM
    ______  ___      _____
    ___   |/  /_____ __  /_______________
    __  /|_/ / _  _ \\_  __/__  ___/_  __ \\
    _  /  / /  /  __// /_  _  /    / /_/ /
    /_/  /_/   \\___/  \\__/ /_/     \\____/

  Thank you for installing metro #{::Metro::VERSION} / #{changes.date}.
  ---------------------------------------------------------------------
  Changes:
  #{changes.changes.map{|change| "  #{change}"}.join("")}
  ---------------------------------------------------------------------
EOM

end
