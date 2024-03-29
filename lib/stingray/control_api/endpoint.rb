require 'uri'
require 'stingray/control_api'

class Stingray::ControlApi::Endpoint
  DEFAULT_AUTH = 'admin:admin'
  DEFAULT_ENDPOINT = "http://localhost:9090/soap"

  class << self
    def full_endpoint_uri
      u = URI.parse(endpoint_uri)
      u.user, u.password = auth
      u.to_s
    end

    def endpoint_uri
      ENV['STINGRAY_ENDPOINT'] || DEFAULT_ENDPOINT
    end

    def auth
      (ENV['STINGRAY_AUTH'] || DEFAULT_AUTH).split(/:/)[0,2]
    end
  end
end
