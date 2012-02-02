require 'mistilteinn/ticket/redmine'

module Mistilteinn
  module Ticket
    def [](name)
      case name.to_sym
      when :redmine
        Mistilteinn::Ticket::Redmine
      end
    end
    module_function :[]
  end
end
