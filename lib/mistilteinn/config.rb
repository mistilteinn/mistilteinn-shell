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
      if File.exist? path then
        self.new(YAML.load_file(path), path)
      else
        self.new({} , path)
      end
    end

    def initialize(hash, path = nil)
      @hash = hash
      @path = path
    end

    def exist?
      File.exist?(@path) if @path
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

      def get(name)
        @hash[name.to_s]
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
