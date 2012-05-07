module Mistilteinn::Cli
  class Info < ::Mistilteinn::Cli::Command
    name :info
    desc 'display information of specified ticket'

    def action
      id = args.first || $1 if ::Mistilteinn::Git::branch.match(/id\/(\d+)/)
      return unless id

      issue = its.info id
      body = <<-END
     ID: #{issue['id']}
Subject: #{issue['name']}
 Author: #{issue['author']}
   Date: #{issue['date']}
      END

      if issue['body'] and not issue['body'].empty?
        body << "\n"
        body << issue['body']
      end

      unless issue['journals'].empty?
        body << "\n\nnotes:\n"

        issue['journals'].each_with_index do |journal, i|
          unless journal['note'] == ''
            body << <<-END
##{i+1} #{journal['name']} #{journal['date']}
#{journal['note']}
            END
          end
        end
      end

      puts body
    end
  end
end
