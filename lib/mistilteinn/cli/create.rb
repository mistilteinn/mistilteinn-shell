module Mistilteinn::Cli
  class Create < ::Mistilteinn::Cli::Command
    name :create
    desc 'create ticket'

    def action
      its.create args.join(' ')
    end
  end
end
