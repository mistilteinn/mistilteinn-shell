#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

require 'open-uri'
require 'json'
require 'net/http'
require 'net/https'

module Mistilteinn
  module HttpUtil
    class HttpError < StandardError; end

    class << self
      def get_json(url, params={})
        url = url.to_s + '?' + params.map{|key,value| "#{key}=#{value}" }.join("&")
        begin
          open(url) do |io|
            JSON.parse(io.read)
          end
        rescue => e
          raise HttpError.new("#{e.message} (#{url})")
        end
      end

      def post_json(url, headers, data)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = url.scheme == 'https'

        http.start do
          ret = http.post(url.path,
                          data.to_json,
                          headers.merge("Content-Type" => "application/json"))
          case ret
          when Net::HTTPSuccess
          else
            raise HttpError.new("#{ret} (#{url})")
          end
        end
      end
    end
  end
end
