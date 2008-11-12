Gem::Specification.new do |s|
  s.name = %q{forgetful}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonathan Palardy"]
  s.date = %q{2008-11-11}
  s.default_executable = %q{forgetful}
  s.description = %q{A minimal command-line implementation of the SuperMemo 2 algorithm.}
  s.email = %q{jonathan.palardy@gmail.com}
  s.executables = ["forgetful"]
  s.extra_rdoc_files = ["bin/forgetful", "lib/csv_ext/reminder.rb", "lib/forgetful.rb", "lib/reminder.rb", "README"]
  s.files = ["bin/forgetful", "examples/katakana_romanji.csv", "examples/romanji_katakana.csv", "lib/csv_ext/reminder.rb", "lib/forgetful.rb", "lib/reminder.rb", "Manifest", "README", "test/test_forgetful.rb", "forgetful.gemspec"]
  s.homepage = %q{http://github.com/jpalardy/forgetful}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Forgetful", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{forgetful}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A minimal command-line implementation of the SuperMemo 2 algorithm.}
  s.test_files = ["test/test_forgetful.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<fastercsv>, [">= 0", "= 1.4"])
    else
      s.add_dependency(%q<fastercsv>, [">= 0", "= 1.4"])
    end
  else
    s.add_dependency(%q<fastercsv>, [">= 0", "= 1.4"])
  end
end
