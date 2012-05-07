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

      def info(id)
        entry = HttpUtil.get_json(api("issues/#{id}"),
                                  { :project_id => @config.project,
                                    :key => @config.apikey,
                                    :include => 'journals'})['issue']
        journals =
          entry['journals'].select{|journal| (not journal.empty?) and
                                             (not journal['notes'].empty?)}.map{|journal|
            ::Mistilteinn::Ticket::Journal.new(journal['id'],
                                               journal['created_on'],
                                               journal['notes'],
                                               journal['user']['name'])
          }
        ::Mistilteinn::Ticket::Entry.new(entry['id'],
                                         entry['subject'],
                                         entry['status']['name'],
                                         entry['author']['name'],
                                         entry['created_on'],
                                         entry['description'],
                                         journals)
      end

      def check
        begin
          HttpUtil.get_json(api('users/current'),
                            { :key => @config.apikey})
          'ok'
        rescue HttpUtil::HttpError => e
          "Error: #{e.message}"
        end
      end

      private
      def api(name)
        URI(@config.url + '/') + "#{name}.json"
      end
    end
  end
end
