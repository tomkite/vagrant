#!/usr/bin/env ruby

master_conf_str = '{
   "name": "master",
   "ip": "172.16.1.100"
}'

slave_conf_str = '{
   "name": "slave",
   "num": 2,
   "ip": "172.16.1.200",
   "ssh-port": 2200
}'

homedir = "#{Dir.home}"

#master
master_conf = JSON.parse(master_conf_str)
hostname = master_conf['name']
ip = master_conf['ip']
puts "master ip=#{ip}"
guest_subs = [ ['<HOST>', hostname], ['<HOSTNAME>', '%h'], ['<PORT>', '22'], ['<KEYBASEPATH>', '/vagrant'] ]
host_subs = [ ['<HOST>', hostname], ['<HOSTNAME>', '127.0.0.1'], ['<PORT>', '2222'], ['<KEYBASEPATH>', Dir.pwd] ]
guest_ssh_config = File.read('ssh-config.template')
host_ssh_config = guest_ssh_config.dup
guest_subs.each {|sub| guest_ssh_config.gsub!(sub[0], sub[1])}
host_subs.each {|sub| host_ssh_config.gsub!(sub[0], sub[1])}
File.open("etc-hosts", 'a') {|f| f.write("#{ip} #{hostname}\n") }
File.open("guest-ssh-config", 'a') {|f| f.write("#{guest_ssh_config}\n") }
File.open("#{Dir.home}/.ssh/config", 'a') {|f| f.write("#{host_ssh_config}\n") }

#slaves
require 'json'
slave_conf = JSON.parse(slave_conf_str)
Range.new(1, slave_conf['num']).each do |n|
   ip_octs = slave_conf['ip'].split('.')
   ip_octs[3] = ip_octs[3].to_i + n
   hostname = slave_conf['name']+n.to_s
   ip = ip_octs.join('.')
   puts "#{hostname} ip=#{ip}"
   port = slave_conf['ssh-port'] + n
   guest_subs = [ ['<HOST>', hostname], ['<HOSTNAME>', '%h'], ['<PORT>', '22'], ['<KEYBASEPATH>', '/vagrant'] ]
   host_subs = [ ['<HOST>', hostname], ['<HOSTNAME>', '127.0.0.1'], ['<PORT>', port.to_s], ['<KEYBASEPATH>', Dir.pwd] ]
   guest_ssh_config = File.read('ssh-config.template')
   host_ssh_config = guest_ssh_config.dup
   guest_subs.each {|sub| guest_ssh_config.gsub!(sub[0], sub[1])}
   host_subs.each {|sub| host_ssh_config.gsub!(sub[0], sub[1])}
   File.open("etc-hosts", 'a') {|f| f.write("#{ip} #{hostname}\n") }
   File.open("guest-ssh-config", 'a') {|f| f.write("#{guest_ssh_config}\n") }
   File.open("#{Dir.home}/.ssh/config", 'a') {|f| f.write("#{host_ssh_config}\n") }
end

Vagrant.configure(2) do |config|
#master
   master = master_conf['name']
   config.vm.define master, primary: true  do |master|
      puts "#{master} ip: " + master_conf['ip']
      master.vm.box = "chef/centos-7.0"
      master.vm.hostname = master_conf['hostname']
      master.vm.network "private_network", ip: master_conf['ip']
      master.vm.synced_folder "../share", "/share"
      master.vm.provision "file", source: "./guest-ssh-config", destination: "~/.ssh/config"
      master.vm.provision "file", source: "./etc-hosts", destination: "/tmp/etc-hosts"
      master.vm.provision "shell", privileged: true, inline: "cat /tmp/etc-hosts >> /etc/hosts"
   end

#slaves
   Range.new(1, slave_conf['num']).each do |n|
      node = slave_conf['name'] + n.to_s
      config.vm.define node do |node|
         octs = slave_conf['ip'].split('.')
         octs[3] = octs[3].to_i + n
         ip = octs.join('.')
         puts "#{node} ip: #{ip}"
         node.vm.box = "chef/centos-7.0"
         node.vm.hostname = slave_conf['name'] + n.to_s
         node.vm.network "private_network", ip: ip
         node.vm.network "forwarded_port", guest: 22, host: slave_conf['ssh-port'] + n
         node.vm.synced_folder "../share", "/share"
         node.vm.provision "file", source: "./guest-ssh-config", destination: "~/.ssh/config"
         node.vm.provision "file", source: "./etc-hosts", destination: "/tmp/etc-hosts"
         node.vm.provision "shell", privileged: true, inline: "cat /tmp/etc-hosts >> /etc/hosts"
      end
   end   

end
