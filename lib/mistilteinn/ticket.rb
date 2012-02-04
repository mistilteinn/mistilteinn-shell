require 'mistilteinn/ticket/redmine'
require 'mistilteinn/ticket/github'
require 'mistilteinn/ticket/git_config'

module Mistilteinn
  module Ticket
    def [](name)
      case name.to_sym
      when :redmine
        Mistilteinn::Ticket::Redmine
      when :github
        Mistilteinn::Ticket::Github
      when :gitconfig
        Mistilteinn::Ticket::GitConfig
      end
    end
    module_function :[]
  end
end
