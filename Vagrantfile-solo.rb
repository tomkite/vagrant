Vagrant.configure(2) do |config|
  config.vm.box = "chef/centos-7.0"
  config.vm.hostname = "centos7"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "public_network", bridge: 'en0: Wi-Fi (AirPort)'
  config.vm.synced_folder "../share", "/share"
end
