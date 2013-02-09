describe Stingray::ControlApi do
  it 'should generate classes on the fly for each configuration namespace' do
    Stingray::ControlApi::AFM.should_not be_nil
    Stingray::ControlApi::AlertCallback.should_not be_nil
    Stingray::ControlApi::AlertingAction.should_not be_nil
    Stingray::ControlApi::AlertingEventType.should_not be_nil
    Stingray::ControlApi::CatalogAptimizerProfile.should_not be_nil
    Stingray::ControlApi::CatalogAuthenticators.should_not be_nil
    Stingray::ControlApi::CatalogBandwidth.should_not be_nil
    Stingray::ControlApi::CatalogJavaExtension.should_not be_nil
    Stingray::ControlApi::CatalogMonitor.should_not be_nil
    Stingray::ControlApi::CatalogPersistence.should_not be_nil
    Stingray::ControlApi::CatalogProtection.should_not be_nil
    Stingray::ControlApi::CatalogRate.should_not be_nil
    Stingray::ControlApi::CatalogRule.should_not be_nil
    Stingray::ControlApi::CatalogSLM.should_not be_nil
    Stingray::ControlApi::CatalogSSLCertificateAuthorities.should_not be_nil
    Stingray::ControlApi::CatalogSSLCertificates.should_not be_nil
    Stingray::ControlApi::CatalogSSLClientCertificates.should_not be_nil
    Stingray::ControlApi::CatalogSSLDNSSEC.should_not be_nil
    Stingray::ControlApi::ConfExtra10.should_not be_nil
    Stingray::ControlApi::ConfExtra.should_not be_nil
    Stingray::ControlApi::Diagnose10.should_not be_nil
    Stingray::ControlApi::Diagnose.should_not be_nil
    Stingray::ControlApi::GLBService.should_not be_nil
    Stingray::ControlApi::GlobalSettings.should_not be_nil
    Stingray::ControlApi::Location.should_not be_nil
    Stingray::ControlApi::Pool.should_not be_nil
    Stingray::ControlApi::SystemAccessLogs.should_not be_nil
    Stingray::ControlApi::SystemBackups.should_not be_nil
    Stingray::ControlApi::SystemCache10.should_not be_nil
    Stingray::ControlApi::SystemCache11.should_not be_nil
    Stingray::ControlApi::SystemCache.should_not be_nil
    Stingray::ControlApi::SystemCloudCredentials.should_not be_nil
    Stingray::ControlApi::SystemConnections.should_not be_nil
    Stingray::ControlApi::SystemLicenseKeys.should_not be_nil
    Stingray::ControlApi::SystemLog.should_not be_nil
    Stingray::ControlApi::SystemMachineInfo.should_not be_nil
    Stingray::ControlApi::SystemManagement.should_not be_nil
    Stingray::ControlApi::SystemRequestLogs.should_not be_nil
    Stingray::ControlApi::SystemStats.should_not be_nil
    Stingray::ControlApi::SystemSteelhead.should_not be_nil
    Stingray::ControlApi::TrafficIPGroups.should_not be_nil
    Stingray::ControlApi::Users.should_not be_nil
    Stingray::ControlApi::VirtualServer.should_not be_nil
  end

  it 'should bubble up const missing errors for invalid configuration namespaces' do
    expect { Stingray::ControlApi::FizzBuzz }.to raise_error
  end
end
