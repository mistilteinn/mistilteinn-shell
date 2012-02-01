#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

require 'yaml'
require 'ostruct'
require 'mistilteinn/git'

module Mistilteinn
  class ConfigError < StandardError
  end

  class Config
    def self.load(path)
      self.new(YAML.load_file(path))
    end

    def initialize(hash)
      @hash = hash
    end

    def method_missing(name, *args)
      if args.empty? then
        key = name.to_s
        WrapObj.new(key, @hash[key] || {} )
      else
        super(name, *args)
      end
    end

    class WrapObj
      def initialize(name, hash)
        @name = name
        @hash = hash
      end

      def method_missing(name, *args)
        key = name.to_s
        super(name, *args) unless args.empty?
        @hash[key] or
          ::Mistilteinn::Git.config("#{@name}.#{key}") or
          raise ConfigError.new("no config(#{@name}.#{key})")
      end
    end
  end
end
