#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-
require 'uri'
require 'mistilteinn/http_util'
require 'mistilteinn/ticket/entry'

module Mistilteinn
  module Ticket
    class Redmine
      def initialize(config)
        @config = config.redmine
      end

      def tickets
        HttpUtil.get_json(api('issues'),
                          { :project_id => @config.project,
                            :key => @config.apikey})['issues'].map{|entry|
          ::Mistilteinn::Ticket::Entry.new(entry['id'],
                                           entry['subject'],
                                           entry['status']['name'])
        }
      end

      def create(title)
        HttpUtil.post_json(api('issues'),
                           { "X-Redmine-API-Key" => @config.apikey },
                           { :issue => {
                               :project_id => @config.project,
                               :subject => title,
                             }})
      end

      private
      def api(name)
        URI(@config.url + '/') + "#{name}.json"
      end
    end
  end
end
