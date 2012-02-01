#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

module Mistilteinn
  module Git
    def config(name)
      str = %x(git config #{name} 2>/dev/null || echo "").strip
      if str.empty? then
        nil
      else
        str
      end
    end
    module_function :config
  end
end
