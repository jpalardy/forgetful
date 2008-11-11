
spec = Gem::Specification.new do |s|
  s.name                  = GitRemoteBranch::NAME
  s.version               = GitRemoteBranch::VERSION::STRING
  s.summary               = "git_remote_branch eases the interaction with remote branches"
  s.description           = "git_remote_branch is a learning tool to ease the interaction with " +
                            "remote branches in simple situations."

  s.authors               = ['Mathieu Martin', 'Carl Mercier']
  s.email                 = "webmat@gmail.com"
  s.homepage              = "http://github.com/webmat/git_remote_branch"
  s.rubyforge_project     = 'grb'

  s.has_rdoc              = false

  s.test_files            = Dir['test/**/*']
  s.files                 = Dir['**/*'].reject{|f| f =~ /\Apkg|\Acoverage|\Ardoc|\.gemspec\Z/}

  s.executable            = 'grb'
  s.bindir                = "bin"
  s.require_path          = "lib"

  s.add_dependency( 'colored', '>= 1.1' )
end

