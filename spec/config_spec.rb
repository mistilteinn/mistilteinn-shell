#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

require 'spec_helper'

spec 'config' do
  describe 'load from file' do
    before do
      File.should_receive(:exist?) { true }
      YAML.should_receive(:load_file) {
        {'ticket' => {
            'source' => 'local',
            'path'   => '/path/to/ticket.txt'
          }}}
    end

    context 'ticket' do
      subject { Mistilteinn::Config.load('config.yml').ticket }
      its(:source) { should == 'local' }
      its(:path)   { should == '/path/to/ticket.txt' }
    end
  end

  describe 'get config from git-config instead of ymal' do
    before do
      File.should_receive(:exist?) { true }
      YAML.should_receive(:load_file) {
        {'ticket' => {
            'source' => 'local',
            'path'   => '/path/to/ticket.txt'
          }}}
      Mistilteinn::Git.should_receive(:config).with('ticket.apikey') { 'xxxx' }
      @config = Mistilteinn::Config.load('config.yml')
    end

    subject { @config.ticket }
    its(:apikey) { should == 'xxxx' }
  end

  describe 'load error' do
    before { @config = Mistilteinn::Config.new({}) }
    it {
      expect { @config.ticket.x }.to raise_error(Mistilteinn::ConfigError)
    }
  end
end
