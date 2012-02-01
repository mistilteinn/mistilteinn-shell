#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

require 'spec_helper'

spec 'config' do
  describe 'load from file' do
    before do
      YAML.should_receive(:load_file) {
        {'ticket' => {
            'source' => 'local',
            'path'   => '/path/to/ticket.txt'
          }}}

      @config = Mistilteinn::Config.load('config.yml')
    end

    context 'ticket' do
      subject { @config.ticket }
      its(:source) { should == 'local' }
      its(:path)   { should == '/path/to/ticket.txt' }
    end
  end
end
