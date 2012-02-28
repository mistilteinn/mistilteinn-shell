module Mistilteinn::Cli
  class Edit < ::Mistilteinn::Cli::Command
    name :edit
    desc 'edit specified ticket'

    def action
      its.edit args
    end
  end
end

