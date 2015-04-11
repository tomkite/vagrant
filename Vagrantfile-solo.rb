puts "outside config"
master = "centos7"
#idfile = ".vagrant/machines/#{master}/virtualbox/id"

case ARGV[0]
when "provision", "up"
  system "./echo-hi.sh"
else
  system "echo nosh"
  # do nothing
end

#if ! File.exists?(idfile)
   Vagrant.configure(2) do |config|
      puts "inside config"
      config.vm.define master do |node|
         puts "inside node"
         #node.vm.provision :host_shell do |shell|
           #shell.inline = './echo-hi.sh'
           #shell.abort_on_nonzero = true
         #end
         node.vm.provision "shell", inline: "echo hello"
         node.vm.box = "chef/centos-7.0"
         node.vm.hostname = "centos7"
         node.vm.network "forwarded_port", guest: 8080, host: 10080
         node.vm.network "public_network", bridge: 'en0: Wi-Fi (AirPort)'
         node.vm.synced_folder "../share", "/share"
      end
   end
#end
