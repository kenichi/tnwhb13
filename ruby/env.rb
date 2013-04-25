module Turmeric
  ROOT = File.dirname __FILE__
  LIB_DIR = File.join ROOT, 'lib'
  APP_FILE = File.join ROOT, 'app'
end

ENV['RACK_ENV'] ||= 'development'
require 'stringio'
require 'openssl'
require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

Dir[File.join(Turmeric::LIB_DIR, '*.rb')].each {|f| require f}
require Turmeric::APP_FILE

class ::String; include ::Term::ANSIColor; end

Bol.configure do |c|
  c.access_key = '611BA3C95D064C10BAA4DD93A9BBC87D'
  c.secret = 'ED7C1C94192CFBF5BC69507A38BF3B874176D7ACFB49EAE30246D62CA5FC50AAD702D4E13D6D6ACD7709338B353B1AFA3379977BEE236EF18554E28120EEBB59F40ABF61D241BC1E48AD2A0EC563A7E1CBE85B7CD1EFFA903242A530BA2793EB457793D4655C3B2FF02B65FFDF0DA1DD79A90B042723506E69C7126A4711827D'
  c.per_page = 10
end
