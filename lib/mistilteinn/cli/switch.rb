module Mistilteinn::Cli
  class Switch < ::Mistilteinn::Cli::Command
    name :switch
    desc 'checkout topic branch of specified ticket'

    def initialize(obj)
      @options = Hash.new(true)

      super(obj) do |opts|
        opts.on("-n", "--[no-]check", "check whether specified ticket exists") do |v|
          @options[:check_ticket] = v
        end
      end
    end

    def action
      return unless args[0]
      ticket_id = args[0].to_i

      if @options[:check_ticket] then
        unless its.tickets.find {|entry| entry.id == ticket_id} then
          puts "no such ticket: #{ticket_id}"
          return
        end
      end

      ::Mistilteinn::Git::checkout ticket_id
    end
  end
end
