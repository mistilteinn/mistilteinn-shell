

module Mistilteinn
  module Ticket
    Entry = Struct.new 'Entry', :id, :name, :status, :author, :date, :body, :journals
    Journal = Struct.new 'Journal', :id, :date, :note, :name

    class Entry
      def format
        "#{id} #{name} [#{status}]"
      end
    end
  end
end
