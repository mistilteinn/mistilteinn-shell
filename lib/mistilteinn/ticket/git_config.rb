# -*- mode:ruby; coding:utf-8 -*-
require 'tempfile'

class Tempfile
  def edit(editor=nil)
    mtime_before_edit = self.mtime
    self.close
    system "#{editor || ENV["EDITOR"]} #{self.path}"
    self.open
    return self.mtime != mtime_before_edit
  end
  def content=(content)
    self.rewind
    self.write content
  end
end

module Mistilteinn
  module Ticket
    class GitConfig
      def initialize(config)
      end

      def tickets
        last_ticket_no = ::Mistilteinn::Git.config "ticket.ticketno"
        (1...last_ticket_no.to_i).map do |id|
          subject = ::Mistilteinn::Git.config "ticket.id/#{id}.subject"
          status  = ::Mistilteinn::Git.config "ticket.id/#{id}.status"
          ::Mistilteinn::Ticket::Entry.new(id, subject, status)
        end
      end

      def create(title = "")
        tmpfile = Tempfile.new 'tmp'
        tmpfile.content = ticket_format({
          :subject => title,
          :author  => ::Mistilteinn::Git::config("user.name"),
          :date    => Time.now,
          :status  => "new"
        })
        tmpfile.edit default_editor

        ticket_no = (::Mistilteinn::Git.config("ticket.ticketno") || "1").to_i
        File::open(tmpfile.path) do |f|
          YAML.load_documents(f) do |yaml|
            yaml.each do |key, value|
              ::Mistilteinn::Git.config("ticket.id/#{ticket_no}.#{key}", "\"#{value}\"")
            end
          end
        end
        ::Mistilteinn::Git.config("ticket.ticketno", (ticket_no+1).to_s)

        tmpfile.unlink
      end

      def edit(id)
        tmpfile = Tempfile.new 'tmp'
        tmpfile.content = ticket_format({
          :subject     => ::Mistilteinn::Git.config("ticket.id/#{id}.subject"),
          :author      => ::Mistilteinn::Git.config("ticket.id/#{id}.author"),
          :date        => ::Mistilteinn::Git.config("ticket.id/#{id}.date"),
          :status      => ::Mistilteinn::Git.config("ticket.id/#{id}.status"),
          :description => ::Mistilteinn::Git.config("ticket.id/#{id}.description")
        })
        modified = tmpfile.edit default_editor

        if modified then
          File::open(tmpfile.path) do |f|
            YAML.load_documents(f) do |yaml|
              yaml.each do |key, value|
                ::Mistilteinn::Git.config("ticket.id/#{id}.#{key}", "\"#{value}\"")
              end
            end
          end
        end

        tmpfile.unlink
      end

      private
      def default_editor
        ::Mistilteinn::Git.config "core.editor"
      end

      def ticket_format(data = {})
        <<END
Subject: #{data[:subject]}
Author: #{data[:author]}
Date: #{data[:date]}
Status: #{data[:status]}
Description: |-
  #{data[:description]}
END
      end

    end
  end
end

