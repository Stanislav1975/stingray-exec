require 'yaml'
require 'stingray/control_api'

class Stingray::ControlApi::Actions
  class << self
    Stingray::ControlApi::CONFIGURATIONS.each do |cfg_ns,variations|
      define_method(:"#{variations[:snaked]}_action_map") do
        bidi_map = {}

        actions_for(cfg_ns).each do |action,action_cfg|
          camelized = File.basename(action_cfg[:action])
          bidi_map[action] = camelized
          bidi_map[camelized] = action
        end

        bidi_map
      end

      define_method(:"#{variations[:snaked]}_namespace") do
        ns(cfg_ns)
      end
    end

    private
    def ns(cfg)
      "#{File.dirname(generated_actions.fetch(cfg).values.first[:action])}/"
    rescue => e
      $stderr.puts "#{e.class.name}:#{e.message} -> #{e.backtrace.join("\n")}" if ENV['DEBUG']
      "http://soap.zeus.com/zxtm/1.0/#{cfg}/"
    end

    def actions_for(cfg)
      generated_actions.fetch(cfg)
    end

    def generated_actions
      @generated_actions ||= begin
        actions = {}

        ver = ENV['STINGRAY_VERSION'] || '9.1'
        File.open(File.expand_path("../generated-actions-#{ver}.yml", __FILE__)) do |f|
          actions.merge!(YAML.load(f))
        end

        actions
      end
    end
  end
end
