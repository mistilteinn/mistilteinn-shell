module Mistilteinn::Cli
  class SelfCheck < ::Mistilteinn::Cli::Command
    name 'self-check'
    desc 'check whether mistilteinn works'

    def action
      section "ticket source"
      check("source type") {
        its.class rescue error("'#{config.ticket.source}' is not valid.")
      }
      check(its.class){ its.check }

      section "git"
      check_if("inside work tree?") { Mistilteinn::Git.work_tree? }
      check_if("git-now subcommand") { Mistilteinn::Git.command? 'now' }
      check_if("git-master subcommand") { Mistilteinn::Git.command? 'master' }
      check_if("git-hooks subcommand") { Mistilteinn::Git.command? 'hooks' }

      puts '','Works! Have a good programming!!'
    rescue => e
      puts <<END
#{e.message}

Oh, Mistilteinn does not work.
Please check your system or configure file.
END
      exit 1
    end

    def error(msg)
      raise StandardError.new(msg)
    end

    def section(title)
      puts <<END

------------------------------
#{title}
------------------------------
END
    end

    def check(title, &f)
      print title, " => "
      STDOUT.flush
      puts f.call
    end

    def check_if(title, &p)
      check(title) {
        if p[] then
          "ok"
        else
          error("error")
        end
      }
    end
  end
end
