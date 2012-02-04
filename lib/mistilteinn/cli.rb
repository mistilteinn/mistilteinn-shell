# -*- mode:ruby; coding:utf-8 -*-
require 'mistilteinn/cli/command'

Dir[File.dirname(__FILE__) + '/cli/*.rb'].each do|name|
  require "mistilteinn/cli/#{File.basename name, '.rb'}"
end
