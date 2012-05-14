#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-
require 'net/http'
require 'uri'
require 'json'
require 'mistilteinn/http_util'
require 'mistilteinn/ticket/entry'

module Mistilteinn
  module Ticket
    class Jira
      def initialize(config)
        @config = config.jira
        @cookie = "" 
      end

      def tickets
        login

        uri = URI.parse "#{@config.url}/rest/api/latest/search" 
        params = {"jql" => "assignee=#{@config.username}",
                  "maxResults" => "10"}
        HttpUtil::get_json(uri, params, {'Cookie' => @cookie})["issues"].map do |issue|
          info(issue["key"])
        end
      end

      def create(title)
        puts "Not supported yet :(" 
      end

      def info(id)
        login

        uri = URI.parse "#{@config.url}/rest/api/latest/issue/#{id}" 
        fields = HttpUtil.get_json(uri, {}, {'Cookie' => @cookie})["fields"]
        journals = fields["comment"]["value"].map do |comment|
          ::Mistilteinn::Ticket::Journal.new(0,
                                             comment["created"],
                                             comment["body"],
                                             comment["author"]["displayName"])
        end

        ::Mistilteinn::Ticket::Entry.new(id,
                                         fields["summary"]["value"],
                                         fields["status"]["value"]["name"],
                                         fields["reporter"]["value"]["displayName"],
                                         fields["created"]["value"],
                                         fields["description"]["value"],
                                         journals)
      end

      def check
        begin
          login
          'ok'
        rescue HttpUtil::HttpError => e
          "Error: #{e.message}" 
        end
      end

      private
      def login
        return unless @cookie.empty?

        uri = URI.parse "#{@config.url}/rest/auth/latest/session" 
        body = {"username" => @config.username, "password" => @config.password}
        response = HttpUtil.post_json(uri , {}, body)
        response.get_fields('Set-Cookie').each do |str|
          k,v = str[0...str.index(';')].split('=')
          @cookie += "#{k}=#{v};" unless v == '""'
        end
      end

    end
  end
end
