# -*- mode:ruby; coding:utf-8 -*-
require File.expand_path('../lib/mistilteinn/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["MIZUNO Hiroki"]
  gem.email         = ["mzp.ppp@gmail.com"]
  gem.description   = %q{Mistilteinn is a command to support a development with git and redmine.}
  gem.summary       = %q{Mistilteinn is a command to support a development with git and redmine.}
  gem.homepage      = "https://github.com/mistilteinn/mistilteinn-shell"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  exclude_from_gem  = File::read('.excluded_from_gem').split("\n")
  gem.files         = `git ls-files`.split("\n").reject do |file|
    exclude_from_gem.include? file
  end
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "mistilteinn"
  gem.require_paths = ["lib"]
  gem.version       = Mistilteinn::VERSION

  gem.add_dependency 'json', ['>= 0'] unless defined? JSON
  gem.add_dependency 'subcommand', ['>= 0']
  gem.add_development_dependency 'rspec', ['>= 0']
  gem.add_development_dependency 'rake', ['>= 0']
end
