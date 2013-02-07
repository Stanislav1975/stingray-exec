require 'rubygems'
require 'bundler/setup'

require 'rbconfig'
require 'simplecov'

RSpec.configure do |c|
  if !ENV['TRAVIS']
    if RbConfig::CONFIG['host_os'] =~ /darwin/i
      c.formatter = 'NyanCatMusicFormatter'
    else
      c.formatter = 'NyanCatFormatter'
    end
  end
end
