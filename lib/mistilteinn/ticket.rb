require 'mistilteinn/ticket/redmine'
require 'mistilteinn/ticket/github'

module Mistilteinn
  module Ticket
    def [](name)
      case name.to_sym
      when :redmine
        Mistilteinn::Ticket::Redmine
      when :github
        Mistilteinn::Ticket::Github
      end
    end
    module_function :[]
  end
end
