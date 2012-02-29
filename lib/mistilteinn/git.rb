#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

module Mistilteinn
  module Git
    class << self
      def config(name, value=nil)
        cmd "git config #{name} #{value or ''}"
      end

      def root
        cmd "git rev-parse --show-toplevel"
      end

      def work_tree?()
        cmd("git rev-parse --is-inside-work-tree") == "true"
      end

      def command?(cmd)
        cmd("which git-#{cmd}") != nil
      end

      private
      def cmd(str)
        str = %x(#{str} 2>/dev/null || echo "").strip
        str.empty? ? nil : str
      end
    end
  end
end
