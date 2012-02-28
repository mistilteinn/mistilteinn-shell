# -*- mode:ruby; coding:utf-8 -*-
require 'tempfile'

class Tempfile
  def edit(editor=nil)
    mtime_before_edit = self.mtime
    self.close
    system "#{editor || ENV["EDITOR"]} #{self.path}"
    self.open
    return self.mtime != mtime_before_edit
  end
  def content=(content)
    self.rewind
    self.write content
  end
end

module Mistilteinn
  module Ticket
    class Config
      class ConfigError < StandardError; end

      def initialize(config_hash, path)
        @config = config_hash
        @path = path
      end
      attr_reader :config

      def has_key?(key)
        @config.has_key?(key) || @config.has_key?(key.to_s)
      end

      def empty?
        @config.empty?
      end

      def []=(*args)
        assignment(args[0], args[1])
      end

      def [](key)
        key = key.to_s if key.class == Symbol
        method_missing(key)
      end

      def method_missing(name, *args)
        name = name.to_s
        name.slice! -1 if method_is_assignment = name.end_with?("=")
        name.slice! -1 if create_obj_if_nil = name.end_with?("_")

        if method_is_assignment then
          assignment(name, args[0])
        else
          config_object = get_config_object(@path+[name.to_s])
          return nil if config_object.empty? and not create_obj_if_nil

          case config_object.config
          when Hash   then config_object
          when String then config_object.config
          else raise ConfigError.new
          end
        end
      end

      private
      def get_config_object(path)
        return @@config_objects[path] if @@config_objects.has_key? path

        if @config.has_key? path[-1] then
          @@config_objects[path] = Config::new(@config[path[-1]], path)
        else
          @config[path[-1]] = {}
          @@config_objects[path] = Config::new({}, path)
        end
      end

      def Config::init
        @@config_objects = {[] => Config::parse_config}
        @@config_objects[[]]
      end

      def Config::parse_config
        config_hash = {}
        get_by_regexp('".*"').each do |path,value|
          subconfig = config_hash
          elems = path.split '.'
          elems[0..-2].each do |path|
            subconfig[path] = {} if subconfig[path].nil?
            subconfig = subconfig[path]
          end
          subconfig[elems[-1]] = value
        end
        Config::new(config_hash, [])
      end

      def Config::get_by_regexp(regex)
        %x(git config --get-regexp #{regex}).split(/\n/).map do |line|
          line.match(/(.+?) (.*)/)[1..2]
        end
      end

      def Config::set(name, value)
        %x(git config #{name} "#{value}")
      end

      def assignment(key, value)
        Config::set("#{@path.join('.')}.#{key}", value)
      end
    end

    class GitConfig
      class ConfigError < StandardError; end

      def initialize(config)
        @config = Config::init
      end

      def tickets
        lastTicketNo = @config.ticket.ticketno.to_i
        (1...lastTicketNo).map do |id|
          data = @config.ticket["id/#{id}"]
          ::Mistilteinn::Ticket::Entry.new(id, data.subject, data.status)
        end
      end

      def create(title = "")
        ticket_format = <<END
Subject: #{title}
Author: #{@config.user.name}
Date: #{Time.now}
Status: new
Description: |-

END

        tmpfile = Tempfile.new 'tmp'
        tmpfile.content = ticket_format({
          subject => title,
          author  => ::Mistilteinn::Config.get("user.name"),
          date    => Time.now,
          status  => "new"
        })

        ticket_no = (::Mistilteinn::Git.config "ticket.ticketno" || "1").to_i
      
        File::open(tmpfile.path) do |f|
          YAML.load_documents(f) do |yaml|
            yaml.each do |key, value|
              ::Mistilteinn::Git.config("ticket.id/#{ticket_no}.#{key}", value)
            end
          end
        end
        ::Mistilteinn::Git.config("ticket.ticketno", (ticket_no+1).to_s)

        tmpfile.unlink
      end

      def edit(id)
        ticket_format = <<END
Subject: #{ticket_data.subject}
Author: #{ticket_data.author}
Date: #{ticket_data.date}
Status: #{ticket_data.status}
Description: |-
  #{ticket_data.description}
END

        tmpfile = Tempfile.new 'tmp'
        tmpfile.content = ticket_format
        modified = tmpfile.edit @git.config.core_.editor

        if modified then
          File::open(tmpfile.path) do |f|
            YAML.load_documents(f) do |yaml|
              yaml.each do |key, value|
                ::Mistilteinn::Git.config("ticket.id/#{id}.#{key}", "\"#{value}\"")
              end
            end
          end
        end

        tmpfile.unlink
      end

    end
  end
end

