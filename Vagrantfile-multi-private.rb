Vagrant.configure(2) do |config|
   config.vm.define "master", primary: true  do |master|
      master.vm.box = "chef/centos-7.0"
      master.vm.hostname = "master"
      #master.vm.network "private_network", type: "dhcp"
      master.vm.network "private_network", ip: "172.16.1.100"
      #master.vm.network "forwarded_port", guest: 80, host: 8080
      #master.vm.network "forwarded_port", guest: 22, host: 2222, auto_correct: true
      master.vm.synced_folder "../share", "/share"
      $script = <<SCRIPT
echo provisioning...
echo '172.16.1.100 master\n172.16.1.201 slave1\n172.16.1.202 slave2' >> /etc/hosts
SCRIPT
      master.vm.provision "shell", inline: $script
      master.vm.provision "file", source: "./ssh-config", destination: "~/.ssh/config"
   end

   (1..2).each do |n|
      node = "slave#{n}"
      config.vm.define node do |node|
         node.vm.box = "chef/centos-7.0"
         node.vm.hostname = "slave#{n}"
         node.vm.network "private_network", ip: "172.16.1.20#{n}"
         node.vm.network "forwarded_port", guest: 22, host: "220#{n}"
         node.vm.synced_folder "../share", "/share"
         node.vm.provision "shell", inline: "cat /vagrant/etc-hosts >> /etc/hosts"
         node.vm.provision "file", source: "./ssh-config", destination: "~/.ssh/config"
      end
   end
end
