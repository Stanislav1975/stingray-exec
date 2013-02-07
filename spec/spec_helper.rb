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

  unless ENV['STINGRAY_ENDPOINT']
    c.filter_run_excluding :integration => true
  end
end
