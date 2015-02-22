Vagrant.configure(2) do |config|
  config.vm.define "master", primary: true  do |master|
    master.vm.box = "chef/centos-7.0"
    master.vm.hostname = "master"
    master.vm.network "public_network", bridge: 'en0: Wi-Fi (AirPort)'
    master.vm.synced_folder "../share", "/share"
    master.vm.provision "shell", inline: "echo master"
  end
  config.vm.define "slave1" do |slave1|
    slave1.vm.box = "chef/centos-7.0"
    slave1.vm.hostname = "slave1"
    #slave1.vm.network "forwarded_port", guest: 80, host: 8080
    slave1.vm.network "public_network", bridge: 'en0: Wi-Fi (AirPort)'
    slave1.vm.synced_folder "../share", "/share"
    slave1.vm.provision "shell", inline: "echo slave1"
  end
  config.vm.define "slave2" do |slave2|
    slave2.vm.box = "chef/centos-7.0"
    slave2.vm.hostname = "slave2"
    #slave2.vm.network "forwarded_port", guest: 80, host: 8080
    slave2.vm.network "public_network", bridge: 'en0: Wi-Fi (AirPort)'
    slave2.vm.synced_folder "../share", "/share"
    slave2.vm.provision "shell", inline: "echo slave2"
  end
end
