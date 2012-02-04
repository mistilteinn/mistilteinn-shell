# -*- mode:ruby; coding:utf-8 -*-

module Mistilteinn
  module Cli
    class Command
      attr_reader :its, :config, :args

      def initialize(obj)
        obj.command name do|opts|
          opts.description = 'show current ticket list'
        end
      end

      def its
        klass = Mistilteinn::Ticket[config.ticket.source]
        klass.new config
      end

      def run(config, args)
        @config = config
        @args   = args
        action
      end

      @@klass = []
      class << self
        def inherited(k)
          @@klass << k
        end

        def commands
          @@klass
        end

        def name(x)
          define_method(:name){ x.to_sym }
        end

        def desc(x)
          define_method(:desc){ x }
        end
      end
    end
  end
end


