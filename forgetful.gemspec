
SPEC = Gem::Specification.new do |s|
  s.name                  = 'forgetful'
  s.version               = '0.0.1'
  s.summary               = 'A minimal command-line implementation of the SuperMemo 2 algorithm.'
  s.description           = 'A minimal command-line implementation of the SuperMemo 2 algorithm.'

  s.author                = 'Jonathan Palardy'
  s.email                 = 'jonathan.palardy@gmail.com'
  s.homepage              = 'http://github.com/jpalardy/forgetful'
  s.rubyforge_project     = 'forgetful'

  s.has_rdoc              = false

  s.test_files            = Dir['test/**/*']
  s.files                 = Dir['**/*']

  s.executable            = 'forgetful'
  s.bindir                = 'bin'
  s.require_path          = 'lib'

  s.add_dependency('fastercsv', '>= 1.4')
end

