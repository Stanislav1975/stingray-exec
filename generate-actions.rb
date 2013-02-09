#!/usr/bin/env ruby

require 'wasabi'

USAGE = <<-EOU
Usage: #{File.basename($0)} <stingray-wsdl-dir>

Generate a YAML blob containing all methods found in the WSDL files provided in
the built-in Stingray docs.  This is done so that we can use Savon::Model to
build classes with predefined actions without having to distribute the WSDL
files ourselves, which would be uncool and probably illegal.
EOU
STINGRAY_WSDL_CONFIGURATIONS = %w(
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
)

class ActionsGenerator
  def self.main(argv)
    wsdl_root = argv.first
    if wsdl_root.nil? || wsdl_root.empty?
      $stderr.puts "ERROR: Missing required argument <stingray-wsdl-dir>"
      $stderr.puts(USAGE)
      return 1
    end

    return new(wsdl_root).generate!
  rescue => e
    $stderr.puts "ERROR: #{e.class.name} #{e.message}"
    $stderr.puts e.backtrace.join("\n") if ENV['DEBUG']
    return 2
  end

  def initialize(wsdl_root, out = $stdout)
    @wsdl_root = wsdl_root
    @out = out
  end

  def generate!
    @out.puts generate_actions_json
    return 0
  rescue => e
    $stderr.puts "ERROR: #{e.class.name} #{e.message}"
    $stderr.puts e.backtrace.join("\n") if ENV['DEBUG']
    return 2
  end

  private
  def generate_actions_json
    actions = {}
    STINGRAY_WSDL_CONFIGURATIONS.each do |cfg|
      actions[cfg] = generate_actions_for_config(cfg)
    end

    YAML.dump(actions)
  end

  def generate_actions_for_config(cfg)
    doc = Wasabi.document(File.read("#{@wsdl_root}/#{cfg}.wsdl"))
    sorted_ops = {}
    ops = doc.operations
    ops.keys.sort.each do |k|
      sorted_ops[k] = ops[k]
    end
    sorted_ops
  rescue => e
    $stderr.puts "ERROR: getting operations for #{cfg}: #{e.class.name} #{e.message}"
    $stderr.puts e.backtrace.join("\n") if ENV['DEBUG']
    {}
  end
end

if $0 == __FILE__
  exit(ActionsGenerator.main(ARGV))
end
