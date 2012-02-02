

module Mistilteinn
  module Ticket
    Entry = Struct.new 'Entry', :id, :name, :status

    class Entry
      def format
        "#{id} #{name} [#{status}]"
      end
    end
  end
end
