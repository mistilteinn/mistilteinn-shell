Mistilteinn for shell
==============================

OVERVIEW
------------------------------

Mistilteinn for shell is a comamnd to support a development style for
using git and redmine.

Prerequires
------------------------------

 * Ruby 1.8.7
 * RubyGems 1.4.2 or later
 * git-hooks http://github.com/mistilteinn/git-hooks
 * git subcommands https://github.com/mistilteinn/git-tools

For developer
------------------------------

### Prerequires

    $ bundle install --path vendor/bundle

### Run

    $ bundle exec mistilteinn

### Run test

    $ bundle exec rake spec

### Package

    $ bundle exec rake build

### Install to system

    $ bundle exec rake build
    $ cd pkg
    $ gem install mistilteinn-*.gem

AUTHOR
------------------------------

 * @mzp
