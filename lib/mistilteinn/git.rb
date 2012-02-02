#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

module Mistilteinn
  module Git
    class << self
      def config(name)
        cmd "git config #{name}"
      end

      def root
        cmd "git rev-parse --show-toplevel"
      end

      private
      def cmd(str)
        str = %x(#{str} 2>/dev/null || echo "").strip
        str.empty? ? nil : str
      end
    end
  end
end
