require "bundler/gem_tasks"

begin

  require 'rspec/core/rake_task'

  desc "Run all rspecs"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rspec_opts = '-c'
  end

  task :default => :spec

rescue LoadError
  puts "please install rspec to run tests"
  puts "install with gem install rspec"
end
