require 'pathname'
require 'fileutils'
require 'mistilteinn/git'

module Mistilteinn::Cli
  class Init < ::Mistilteinn::Cli::Command
    name :init
    desc 'initialize this repository for mistilteinn'

    def action
      shell "git hooks on"

      config = Pathname(::Mistilteinn::Git.root) + '.mistilteinn'
      puts "mkdir -p #{config}"
      config.mkpath

      templates.each do|src|
        print "generate #{src.basename}..."
        dest = config + src.basename
        if dest.exist? then
          puts "skip"
        else
          FileUtils.copy src, config
          puts "ok"
        end
      end
    end

    def shell(str)
      puts str
      system str
    end

    def templates
      path = Pathname(File.dirname(__FILE__)) + 'templates'
      path.children
    end
  end
end
