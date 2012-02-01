#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-
require 'uri'
require 'mistilteinn/http_util'
require 'mistilteinn/ticket/entry'

module Mistilteinn
  module Ticket
    class Redmine
      def initialize(config)
        @config = config.ticket
      end

      def tickets
        HttpUtil.get_json(URI(@config.url + '/') + 'issues.json',
                          { :project_id => @config.project,
                            :key => @config.apikey})['issues'].map{|entry|
          ::Mistilteinn::Ticket::Entry.new(entry['subject'],
                                           entry['status']['name'])
        }
      end
    end
  end
end
