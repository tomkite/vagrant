(try)tom:vagrant tom$ vagrant package --output centos7docker
master ip=172.16.1.100
#<Vagrant::Config::V2::Root:0x000001021c36f0> ip: 172.16.1.100
==> master: Attempting graceful shutdown of VM...
==> master: Forcing shutdown of VM...
==> master: Clearing any previously set forwarded ports...
==> master: Exporting VM...
==> master: Compressing package to: /Users/tom/sym/vagrant/centos7docker
(try)tom:vagrant tom$ vagrant box add centos7docker centos7docker

curl -L -O http://buildlogs.centos.org/centos/7/isos/x86_64/CentOS-7.0-1406-x86_64-Minimal.iso

*** 20150818 ***
(try)tom:sym tom$ cd vagrant/
(try)tom:vagrant tom$ vi Vagrantfile
(try)tom:vagrant tom$ vagrant up
Bringing machine 'py-client' up with 'virtualbox' provider...
Bringing machine 'py-server' up with 'virtualbox' provider...
==> py-client: Clearing any previously set forwarded ports...
==> py-client: Clearing any previously set network interfaces...
==> py-client: Preparing network interfaces based on configuration...
    py-client: Adapter 1: nat
    py-client: Adapter 2: hostonly
==> py-client: Forwarding ports...
    py-client: 22 => 2222 (adapter 1)
==> py-client: Booting VM...
==> py-client: Waiting for machine to boot. This may take a few minutes...
    py-client: SSH address: 127.0.0.1:2222
    py-client: SSH username: vagrant
    py-client: SSH auth method: private key
    py-client: Warning: Connection timeout. Retrying...
==> py-client: Machine booted and ready!
==> py-client: Checking for guest additions in VM...
==> py-client: Setting hostname...
==> py-client: Configuring and enabling network interfaces...
==> py-client: Mounting shared folders...
    py-client: /vagrant => /Users/tom/sym/vagrant
==> py-client: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> py-client: to force provisioning. Provisioners marked to run always will still run.
==> py-server: Clearing any previously set forwarded ports...
==> py-server: Fixed port collision for 22 => 2222. Now on port 2200.
==> py-server: Clearing any previously set network interfaces...
==> py-server: Preparing network interfaces based on configuration...
    py-server: Adapter 1: nat
    py-server: Adapter 2: hostonly
==> py-server: Forwarding ports...
    py-server: 22 => 2200 (adapter 1)
==> py-server: Booting VM...
==> py-server: Waiting for machine to boot. This may take a few minutes...
    py-server: SSH address: 127.0.0.1:2200
    py-server: SSH username: vagrant
    py-server: SSH auth method: private key
    py-server: Warning: Connection timeout. Retrying...
==> py-server: Machine booted and ready!
==> py-server: Checking for guest additions in VM...
==> py-server: Setting hostname...
==> py-server: Configuring and enabling network interfaces...
==> py-server: Mounting shared folders...
    py-server: /vagrant => /Users/tom/sym/vagrant
==> py-server: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> py-server: to force provisioning. Provisioners marked to run always will still run.
(try)tom:vagrant tom$ diff Vagrantfile Vagrantfile.salt_master_slave_image-python_postgres_flask_image 
33a34,35
> #!/usr/bin/env ruby
> 
(try)tom:vagrant tom$ cp Vagrantfile Vagrantfile.salt_master_slave_image-python_postgres_flask_image 
(try)tom:vagrant tom$ git add Vagrantfile.salt_master_slave_image-salt_master_slaves Vagrantfile.salt_master_slave_image-python_postgres_flask_image 
(try)tom:vagrant tom$ git commit -m 'use 10.* address in .ssh/config instead of 127.*; created base image for py-dev client/server'
[master a2e2a09] use 10.* address in .ssh/config instead of 127.*; created base image for py-dev client/server
 2 files changed, 80 insertions(+), 16 deletions(-)
 create mode 100644 Vagrantfile.salt_master_slave_image-python_postgres_flask_image
(try)tom:vagrant tom$ git pull
Already up-to-date.
(try)tom:vagrant tom$ git push origin master
Counting objects: 6, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 1.07 KiB | 0 bytes/s, done.
Total 4 (delta 2), reused 0 (delta 0)
To git@github.com:tomkite/vagrant.git
   d5a9879..a2e2a09  master -> master

(try)tom:vagrant tom$ VBoxManage list runningvms
"vagrant_py-client_1438905607905_84036" {96ea4af7-b600-4c03-b4b9-4577bebf8d10}
"vagrant_py-server_1438932834090_72124" {370a7938-2d87-4b53-969e-241ac9be61e7}

(try)tom:vagrant tom$ vagrant box list
/Volumes/Public Share/devel-downloads/prebuilt/prebuilt.box (virtualbox, 0)
centos7docker                                               (virtualbox, 0)
chef/centos-6.5                                             (virtualbox, 1.0.0)
chef/centos-7.0                                             (virtualbox, 1.0.0)
hashicorp/precise32                                         (virtualbox, 1.0.0)
mitchellh/boot2docker                                       (virtualbox, 1.2.0)
salt-master                                                 (virtualbox, 0)
salt-minion                                                 (virtualbox, 0)
sym-chef                                                    (virtualbox, 0)

(try)tom:vagrant tom$ vagrant box add --name py-pg-flask-server py-pg-flask-server
==> box: Adding box 'py-pg-flask-server' (v0) for provider: 
    box: Downloading: file:///Users/tom/sym/vagrant/py-pg-flask-server
==> box: Successfully added box 'py-pg-flask-server' (v0) for 'virtualbox'!
(try)tom:vagrant tom$ vagrant box list
/Volumes/Public Share/devel-downloads/prebuilt/prebuilt.box (virtualbox, 0)
centos7docker                                               (virtualbox, 0)
chef/centos-6.5                                             (virtualbox, 1.0.0)
chef/centos-7.0                                             (virtualbox, 1.0.0)
hashicorp/precise32                                         (virtualbox, 1.0.0)
mitchellh/boot2docker                                       (virtualbox, 1.2.0)
py-pg-flask-server                                          (virtualbox, 0)
salt-master                                                 (virtualbox, 0)
salt-minion                                                 (virtualbox, 0)
sym-chef                                                    (virtualbox, 0)
(try)tom:vagrant tom$ vagrant box add --name py-pg-flask-client py-pg-flask-client
==> box: Adding box 'py-pg-flask-client' (v0) for provider: 
    box: Downloading: file:///Users/tom/sym/vagrant/py-pg-flask-client
==> box: Successfully added box 'py-pg-flask-client' (v0) for 'virtualbox'!
(try)tom:vagrant tom$ 

[vagrant@master logstash]$ sudo yum install ruby
[vagrant@master logstash]$ sudo yum install ruby-devel
[vagrant@master logstash]$ sudo gem install fpm
[vagrant@master logstash]$ sudo gem install pleaserun
[vagrant@master logstash]$ sudo ln -s /vagrant/etc/symphony.repo /etc/yum.repos.d/.
[vagrant@master logstash]$ sudo yum makecashe

