# -*- mode:ruby; coding:utf-8 -*-
require 'mistilteinn/git'

module Mistilteinn::Cli
  class IsInside < ::Mistilteinn::Cli::Command
    name 'is-inside'
    desc 'check if current working direcotry is mistilteinn'

    def action
      if ::Mistilteinn::Git::work_tree? and config.exist? then
        exit 0
      else
        exit 1
      end
    end
  end
end
