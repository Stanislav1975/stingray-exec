require 'stingray/junk'

module Stingray
  module ControlApi
    CONFIGURATIONS = {}.tap do |c|
      %w(
        AFM
        AlertCallback
        Alerting.Action
        Alerting.EventType
        Catalog.Aptimizer.Profile
        Catalog.Authenticators
        Catalog.Bandwidth
        Catalog.JavaExtension
        Catalog.Monitor
        Catalog.Persistence
        Catalog.Protection
        Catalog.Rate
        Catalog.Rule
        Catalog.SLM
        Catalog.SSL.CertificateAuthorities
        Catalog.SSL.Certificates
        Catalog.SSL.ClientCertificates
        Catalog.SSL.DNSSEC
        Conf.Extra_1_0
        Conf.Extra
        Diagnose_1_0
        Diagnose
        GLB.Service
        GlobalSettings
        Location
        Pool
        System.AccessLogs
        System.Backups
        System.Cache_1_0
        System.Cache_1_1
        System.Cache
        System.CloudCredentials
        System.Connections
        System.LicenseKeys
        System.Log
        System.MachineInfo
        System.Management
        System.RequestLogs
        System.Stats
        System.Steelhead
        TrafficIPGroups
        Users
        VirtualServer
      ).each do |cfg|
        c[cfg] = {
          :snaked => Stingray::Junk.snakify(cfg),
          :consted => Stingray::Junk.constify(cfg),
        }
      end
    end
    CONFIGURATIONS_BY_CONST = {}.tap do |c|
      CONFIGURATIONS.each do |k, v|
        c[v[:consted]] = v.merge(:ns => k)
      end
    end

    def self.const_missing(sym)
      const = sym.to_s
      snaked = (CONFIGURATIONS_BY_CONST[const] || {})[:snaked]
      unless snaked
        return super
      end

      require 'savon'
      require 'stingray/control_api/endpoint'
      require 'stingray/control_api/actions'

      const_set(sym, Class.new(Object) do
        extend Savon::Model

        class << self
          attr_accessor :_action_map
        end
        self._action_map = Stingray::ControlApi::Actions.send(:"#{snaked}_action_map")

        actions(*_action_map.keys.map(&:to_sym))
        _action_map.keys.each do |action|
          action_str = action.to_s
          response_key = :"#{action_str}_response"
          define_method(action) do |*args|
            custom_method = :"_custom_#{action_str}"
            if respond_to?(custom_method)
              # use a custom method defined in a *Methods module
              return send(custom_method, *args).body[response_key]
            else
              # fall back to the Savon::Model version
              return super(*args).body[response_key]
            end
          end
        end

        basic_auth(*Stingray::ControlApi::Endpoint.auth)
        endpoint Stingray::ControlApi::Endpoint.full_endpoint_uri
        namespace Stingray::ControlApi::Actions.send(:"#{snaked}_namespace")

        _methods_file = File.expand_path("../control_api/#{snaked}_methods.rb", __FILE__)
        if File.exists?(_methods_file)
          load _methods_file
          instance_eval do
            include Stingray::ControlApi.const_get("#{const}Methods")
          end
        end
      end)
    end
  end
end
