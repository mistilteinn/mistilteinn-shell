#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-
require 'uri'
require 'mistilteinn/http_util'
require 'mistilteinn/ticket/entry'

module Mistilteinn
  module Ticket
    class AtsutaKatze
      def initialize(config)
        @config = config.atsuta_katze
      end

      def tickets
        result = kz "list"
        result.split("\n").map {|line|
          id,title = line.split(' ', 2)
          Entry.new(id, title, "")
        }
      end

      def create(title)
        kz("add -s #{title}")
      end

      def check
        if system("which kz 2>&1 > /dev/null")
          'ok'
        else
          "Error: not found kz"
        end
      end

      private
      def kz(cmd)
        unless @config.home then
          %x(kz #{cmd})
        else
          %x(kz --katze-dir #{@config.home} #{cmd})
        end
      end
    end
  end
end
