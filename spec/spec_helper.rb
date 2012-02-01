# -*- mode:ruby; coding:utf-8 -*-

def spec(name, &f)
  require "mistilteinn/#{name}"
  xs = name.split('/').map{|x| x.capitalize }.join('::')
  describe "Mistilteinn::#{xs}", &f
end
