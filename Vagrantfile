Vagrant::Config.run do |config|
  config.vm.box = 'precise64'
  config.vm.provision :shell, :path => 'install-stingray'
  config.vm.network :bridged, :bridge => ENV['VAGRANT_BRIDGE'] || 'en0: Wi-Fi (AirPort)'
end

# vim:filetype=ruby
