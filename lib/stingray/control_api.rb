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
      snaked = (CONFIGURATIONS_BY_CONST[sym.to_s] || {})[:snaked]
      unless snaked
        return super
      end

      require 'savon'
      require 'stingray/control_api/defaults'

      const_set(sym, Class.new(Object) do
        extend Savon::Model

        _actions = Stingray::ControlApi::Defaults.send(:"#{snaked}_actions")
        actions(*_actions)
        _actions.each do |action|
          define_method(action) do |*args|
            super(*args).body[:"#{action.to_s}_response"]
          end
        end

        basic_auth(*Stingray::ControlApi::Defaults.auth)
        endpoint Stingray::ControlApi::Defaults.endpoint_uri
        namespace Stingray::ControlApi::Defaults.send(:"#{snaked}_namespace")
      end)
    end
  end
end
