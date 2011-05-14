require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "forgetful"
  gem.homepage = "http://github.com/jpalardy/forgetful"
  gem.license = "MIT"
  gem.summary =     "A minimal command-line implementation of the SuperMemo 2 algorithm."
  gem.description = "A minimal command-line implementation of the SuperMemo 2 algorithm."
  gem.email = "jonathan.palardy@gmail.com"
  gem.authors = ["Jonathan Palardy"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

