#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

require 'spec_helper'

spec 'config' do
  subject { Mistilteinn::Config.new }
  its(:source) { should == :local }
end
