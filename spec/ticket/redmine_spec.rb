#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

require 'spec_helper'
require 'uri'
require 'mistilteinn/http_util'

spec 'ticket/redmine' do
  before do
    @config = Mistilteinn::Config.new({ 'redmine' => {
                                          'url' => 'http://example.com/redmine',
                                          'project' => 'some-project',
                                          'apikey' => 'key' }})
    @redmine = Mistilteinn::Ticket::Redmine.new @config
  end

  describe 'ticket list' do
    before do
      Mistilteinn::HttpUtil.should_receive(:get_json).
        with(URI('http://example.com/redmine/issues.json'),
             { :project_id => 'some-project', :key => 'key' }) do
        { "issues" =>
          [
           { "id" => "1", "subject" => "Ticket A", "status" => { "name" => "open" }},
           { "id" => "2", "subject" => "Ticket B", "status" => { "name" => "close" }}
          ]}
      end
    end

    subject { @redmine.tickets }
    its(:length) { should == 2 }

    describe 'Ticket A' do
      subject { @redmine.tickets[0] }
      its(:id)   { should == "1" }
      its(:name) { should == "Ticket A" }
      its(:status) { should == "open" }
    end

    describe 'Ticket B' do
      subject { @redmine.tickets[1] }
      its(:id)   { should == "2" }
      its(:name) { should == "Ticket B" }
      its(:status) { should == "close" }
    end
  end

  describe 'create ticket' do
    it do
      Mistilteinn::HttpUtil.should_receive(:post_json).
        with(URI('http://example.com/redmine/issues.json'),
             { 'X-Redmine-API-Key' => 'key' },
             { :issue => {
                 :project_id => 'some-project',
                 :subject => 'hogehoge'
               }})
      @redmine.create 'hogehoge'
    end
  end

  describe 'self-check' do
    context 'success' do
      before do
        Mistilteinn::HttpUtil.should_receive(:get_json).
          with(URI('http://example.com/redmine/users/current.json'),
               { :key => 'key' }) do {} end
      end

      subject { @redmine }
      its(:check) { should == 'ok' }
    end

    context 'fail' do
      before do
        Mistilteinn::HttpUtil.should_receive(:get_json).
          with(URI('http://example.com/redmine/users/current.json'),
               { :key => 'key' }) do
          raise Mistilteinn::HttpUtil::HttpError.new('foo bar')
        end
      end

      subject { @redmine }
      its(:check) { should == 'Error: foo bar' }
    end
  end
end
