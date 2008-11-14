require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('forgetful', '0.0.6') do |p|
  p.description    = "A minimal command-line implementation of the SuperMemo 2 algorithm."
  p.url            = "http://github.com/jpalardy/forgetful"
  p.author         = "Jonathan Palardy"
  p.email          = "jonathan.palardy@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.has_rdoc       = false
  p.include_rakefile = false
  p.development_dependencies = []
  p.runtime_dependencies = ['fastercsv >= 1.4']
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
