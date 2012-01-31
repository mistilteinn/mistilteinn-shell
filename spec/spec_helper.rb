# -*- mode:ruby; coding:utf-8 -*-

def spec(name, &f)
  require "mistilteinn/#{name}"
  describe "Mistilteinn::#{name.capitalize}", &f
end
