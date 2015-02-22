Vagrant.configure(2) do |config|
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
