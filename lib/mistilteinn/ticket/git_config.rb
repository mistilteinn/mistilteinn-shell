# -*- mode:ruby; coding:utf-8 -*-
require 'tempfile'

module Mistilteinn
  module Ticket
    class Config
      def initialize(config_hash, path)
        @config = config_hash
        @path = path
      end
      attr_reader :config

      def has_key?(key)
        @config.has_key?(key) || @config.has_key?(key.to_s)
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
        is_assignment = create_if_nil = false
        if name[-1..-1] == '=' then
          is_assignment = true
          name.slice! -1
        end
        if name[-1..-1] == '_' then
          create_if_nil = true
          name.slice! -1
        end

        return assignment(name, args[0]) if is_assignment

        config_object = get_config_object(@path+[name.to_s])
        return nil if config_object.config.empty? and not create_if_nil

        if config_object.config.class == Hash then
          config_object
        else
          config_object.config
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
        ticketFormat = <<END
Subject: #{title}
Author: #{@config.user.name}
Date: #{Time.now}
Status: new
Description: |-

END

        editTempFile(ticketFormat) do |f, modified|
          return if not modified and title.empty?

          ticket = @config.ticket
          ticketNo = (ticket.ticketno || "1").to_i

          YAML.load_documents(f) do |yaml|
            yaml.each do |key, value|
              ticket["id/#{ticketNo}_"][key] = value
            end
          end
          ticket.ticketno = (ticketNo+1).to_s
        end
      end

      def edit(id)
      end

      private
      def editTempFile(initialString, &proc)
        tmp = Tempfile.new("tmp")
        tmp.write initialString
        tmp.close

        editor = @config.core_.editor || ENV["EDITOR"]
        system "#{editor} #{tmp.path}"
        File.open(tmp.path) do |f|
          modified = f.read != initialString
          f.rewind
          proc.call(f, modified)
        end
        tmp.unlink
      end
    end
  end
end

