require 'savon'

module Stingray
  module Exec
    def self.configure
      Savon.configure do |config|
        unless ENV['DEBUG']
          config.log = false
          HTTPI.log = false
        end

        yield config if block_given?
      end
    end
  end
end
