require 'stingray/control_api'

class Stingray::ControlApi::Defaults
  DEFAULT_AUTH = 'admin:admin'
  DEFAULT_ENDPOINT_URI = "http://#{DEFAULT_AUTH}@localhost:9090/soap"

  class << self
    def endpoint_uri
      ENV['STINGRAY_ENDPOINT'] || DEFAULT_ENDPOINT_URI
    end

    def auth
      (ENV['STINGRAY_AUTH'] || DEFAULT_AUTH).split(/:/)[0,2]
    end
  end
end
