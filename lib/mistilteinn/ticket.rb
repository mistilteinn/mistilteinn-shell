Dir[File.dirname(__FILE__) + '/ticket/*.rb'].each do|name|
  require "mistilteinn/ticket/#{File.basename name, '.rb'}"
end

module Mistilteinn
  module Ticket
    def [](name)
      case name.to_sym
      when :redmine
        Mistilteinn::Ticket::Redmine
      when :github
        Mistilteinn::Ticket::Github
      when :atsuta_katze
        Mistilteinn::Ticket::AtsutaKatze
      when :gitconfig
        Mistilteinn::Ticket::GitConfig
      when :jira
        Mistilteinn::Ticket::Jira
      end
    end
    module_function :[]
  end
end
