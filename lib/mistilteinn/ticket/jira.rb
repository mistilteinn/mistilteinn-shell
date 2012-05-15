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
        @cookie = {}
      end

      def tickets
        puts "Not supported yet :(" 
        []
      end

      def create(title)
        puts "Not supported yet :(" 
      end

      def info(id)
        login

        uri = URI.parse "#{@config.url}/rest/api/latest/issue/#{id}" 
        Net::HTTP.start(uri.host, uri.port) do |http|
          response = http.get(uri.path, {'Cookie'=>cookie.map{|k,v| "#{k}=#{v}"}.join(';')})
          issue = JSON.parse response.body

          journals = []
          ::Mistilteinn::Ticket::Entry.new(id,
                                           issue["fields"]["summary"]["value"],
                                           issue["fields"]["status"]["value"]["name"],
                                           issue["fields"]["reporter"]["value"]["displayName"],
                                           issue["created"]["value"],
                                           issue["fields"]["description"]["value"],
                                           journals)
        end
      end

      def check
        'ok'
      end

      private
      def login
        uri = URI.parse "#{@config.url}/rest/auth/latest/session" 

        Net::HTTP.start(uri.host, uri.port) do |http|
          header = { "Content-Type" => "application/json" }
          body = "{'username' : '#{@config.username}', 'password' : '#{@config.password}'}" 
          response = http.post(uri.path, body, header)
          response.get_fields('Set-Cookie').each{|str|
            k,v = str[0...str.index(';')].split('=')
            @cookie[k] = v
          }
        end
      end

    end
  end
end
