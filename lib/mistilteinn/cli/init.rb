module Mistilteinn::Cli
  class Init < ::Mistilteinn::Cli::Command
    name :init
    desc 'initialize this repository for mistilteinn'

    def action
      shell "git hooks on"
    end

    def shell(str)
      puts str
      system str
    end
  end
end
