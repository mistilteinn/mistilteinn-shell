#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

require 'open-uri'
require 'json'

module Mistilteinn
  module HttpUtil
    class HttpError < StandardError; end

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

    def post(url, params)
    end

    module_function :get_json
  end
end
