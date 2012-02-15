Mistilteinn for shell
==============================
[![Build Status](https://secure.travis-ci.org/mistilteinn/mistilteinn-shell.png)](http://travis-ci.org/mistilteinn/mistilteinn-shell)

OVERVIEW
------------------------------

Mistilteinn for shell is a comamnd to support a development style for
using git and redmine.

Prerequires
------------------------------

 * Ruby 1.8.7
 * RubyGems 1.4.2 or later
 * git subcommands https://github.com/mistilteinn/git-tools

Install
------------------------------

   $ gem install mistilteinn

Setup for each project
------------------------------

To use mistilteinn, run `mistilteinn init` at each project dirctory.

   $ cd /path/to/project
   $ git init
   $ mistilteinn init
   $ vim .mistilteinn/config.yaml

Usage
------------------------------

### self cehck

Check if miltilteinn works:

   $ mistilteinn self-check

### init

Initialize working directory for mistilteinn:

   $ mistilteinn init
   $ vim .mistilteinn/config.yaml

### list ticket

   $ mistilteinn list

### create ticket

   $ mistilteinn create hoge

Build(developper only)
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
 * @suer
 * @shimomura1004
 * @mallowlabs

License
-----------------------

The MIT License (MIT) Copyright (c) 2012 codefirst.org

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

