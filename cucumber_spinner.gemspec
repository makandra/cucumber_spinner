# -*- encoding: utf-8 -*-
$: << File.expand_path('../lib', __FILE__)
require 'cucumber_spinner/version'

Gem::Specification.new do |gem|
  gem.name = %q{cucumber_spinner}
  gem.authors = ["Tobias Kraze"]
  gem.description = %q{Formatter for cucumber like the RSpecSpinner for RSpec. Shows a progress bar on the command line, prints failing scenarios immediately and can automatically show a browser dump of the error page.}
  gem.summary = gem.description
  gem.email = %q{tobias.kraze@makandra.de}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.version       = CucumberSpinner::VERSION

  gem.add_runtime_dependency(%q<rtui>, [">= 0.2.2"])
end

