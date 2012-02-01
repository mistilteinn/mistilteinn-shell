#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

require 'yaml'
require 'ostruct'

module Mistilteinn
  class Config
    def self.load(path)
      self.new(YAML.load_file(path))
    end

    def initialize(hash)
      @keys = hash.keys
      @obj = make hash
    end

    def method_missing(name, *args)
      if @keys.include?(name.to_s) and args.empty? then
        @obj.send name
      else
        super(name, *args)
      end
    end

    private
    def make(hash)
      hash.each do|key, value|
        if value.class == Hash
          hash[key] = make(value)
        end
      end
      OpenStruct.new hash
    end
  end
end
