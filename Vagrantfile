# -*- mode: ruby -*-
# vi: set ft=ruby sw=2 ts=2 et wrap tw=76 :

Vagrant.configure("2") do |config|
  config.vm.define "debian7" do |debian7|
    debian7.vm.box = "adsy-debian-7"
  end
  config.vm.define "debian8" do |debian8|
    debian8.vm.box = "adsy-debian-8"
  end
  config.vm.define "centos6" do |centos6|
    centos6.vm.box = "adsy-centos-6"
    centos6.ssh.insert_key = false
  end
  config.vm.define "centos7" do |centos7|
    centos7.vm.box = "adsy-centos-7"
    centos7.ssh.insert_key = false
  end
  config.vm.define "ubuntu14" do |ubuntu14|
    ubuntu14.vm.box = "adsy-ubuntu-14"
  end
  config.vm.define "ubuntu16" do |ubuntu16|
    ubuntu16.vm.box = "adsy-ubuntu-16"
  end

  #config.vm.box_check_update = false

  #config.vm.network "forwarded_port", guest: 80, host: 8080
  #config.vm.network "private_network", ip: "192.168.33.10"
  #config.vm.network "public_network"

  #if Dir.exists?('../data')
  #  config.vm.synced_folder "../data", "/vagrant_data"
  #end

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--memory", 512]
  end

  #config.push.define "atlas" do |push|
  #  push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  #end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "./site.yml"
    ansible.sudo = true
    ansible.extra_vars = {
      ansible_ssh_user: 'vagrant',
      ansible_managed: 'Warning: File is managed by Ansible [https://git.adfinis-sygroup.ch/ad-sy/ansible-roles.src]',
    }
  end
end
