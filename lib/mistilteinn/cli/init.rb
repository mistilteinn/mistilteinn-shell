# -*- coding: undecided -*-
require 'pathname'
require 'fileutils'
require 'mistilteinn/git'

module Mistilteinn::Cli
  class Init < ::Mistilteinn::Cli::Command
    name :init
    desc 'initialize this repository for mistilteinn'

    def action
      copy( children('hooks'), git_root('.git/hooks') )
      copy( children('templates'), git_root('.mistilteinn') )
    end

    private
    def children(name)
      path = Pathname(File.dirname(__FILE__)) + name
      path.children
    end

    def git_root(name)
      path = Pathname(::Mistilteinn::Git.root) + name
      path.tap {
        unless path.exist?
          puts "mkdir -p #{config}"
          config.mkpath
        end
      }
    end

    def copy(files, dir)
      puts "copy to #{dir}"
      files.each do|src|
        print "generate #{src.basename}..."
        dest = dir + src.basename
        if dest.exist? then
          puts "skip"
        else
          FileUtils.copy src, dest
          puts "ok"
        end
      end
    end
  end
end
