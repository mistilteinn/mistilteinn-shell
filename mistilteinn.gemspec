# -*- coding: utf-8 -*-
require File.expand_path('../lib/mistilteinn/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["MIZUNO Hiroki"]
  gem.email         = ["mzp.ppp@gmail.com"]
  gem.description   = %q{Mistilteinn is a command to support a development with git and redmine.}
  gem.summary       = %q{Mistilteinn is a command to support a development with git and redmine.}
  gem.homepage      = "https://github.com/mistilteinn/mistilteinn-shell"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "mistilteinn"
  gem.require_paths = ["lib"]
  gem.version       = Mistilteinn::VERSION

  gem.add_dependency 'json', ['>= 0'] unless defined? JSON
  gem.add_development_dependency 'rspec', ['>= 0']
end
