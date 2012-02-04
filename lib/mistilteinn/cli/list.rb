module Mistilteinn::Cli
  class List < ::Mistilteinn::Cli::Command
    name :list
    desc 'show current ticket list'

    def action
      its.tickets.each do|entry|
        puts entry.format
      end
    end
  end
end
