require 'json'
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

    Stingray::ControlApi::CONFIGURATIONS.each do |cfg_ns,variations|
      define_method(:"#{variations[:snaked]}_actions") do
        actions_for(cfg_ns)
      end

      define_method(:"#{variations[:snaked]}_namespace") do
        ns(cfg_ns)
      end
    end

    private
    def ns(cfg)
      "#{File.dirname(generated_actions.fetch(cfg).values.first[:action])}/"
    end

    def actions_for(cfg)
      generated_actions.fetch(cfg).keys.map(&:to_sym)
    end

    def generated_actions
      @generated_actions ||= begin
        actions = {}

        File.open(File.expand_path('../generated-actions.yml', __FILE__)) do |f|
          actions.merge!(YAML.load(f))
        end

        actions
      end
    end
  end
end
