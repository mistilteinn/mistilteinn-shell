# -*- mode:ruby; coding:utf-8 -*-
require 'mistilteinn/http_util'
require 'mistilteinn/ticket/entry'

module Mistilteinn
  module Ticket
    class Github
      class ConfigError < StandardError; end

      API_URL_ROOT = "https://api.github.com/"

      def initialize(config)
        @group = config.github.group
        @project = config.github.project
        unless @group and @project
          raise ConfigError.new
        end
      end

      def tickets
        ::Mistilteinn::HttpUtil::get_json(api("issues")).map do |issue|
          ::Mistilteinn::Ticket::Entry.new(issue['number'],
                                           issue['title'],
                                           issue['state'])
        end
      end

      def create(title)
        # FIXME or DIE
      end

      private
      def api(name)
        URI(API_URL_ROOT) + "./repos/#{@group}/#{@project}/#{name}"
      end
    end
  end
end
