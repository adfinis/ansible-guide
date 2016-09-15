# -*- mode: ruby -*-
# vi: set ft=ruby sw=2 ts=2 et wrap tw=76 :

Vagrant.configure("2") do |config|
  config.vm.define "debian7" do |debian7|
    debian7.vm.box = "adsy-debian-7.7.0.box"
    debian7.vm.box_url = "https://pkg.adfinis-sygroup.ch/vagrant/adsy-debian-7.7.0.box"
    debian7.vm.box_download_checksum = "c39829c2f21b1081000347eda24234362007690ccb514b77b888e2d213e7b150"
    debian7.vm.box_download_checksum_type = "sha256"
  end
  config.vm.define "debian8" do |debian8|
    debian8.vm.box = "adsy-debian-8.0.0.box"
    debian8.vm.box_url = "https://pkg.adfinis-sygroup.ch/vagrant/adsy-debian-8.0.0.box"
    debian8.vm.box_download_checksum = "69ff0f7fe316a78fda94f3ed090a13a84ee25480f38f9d0b12adb1ae8f0ed9a9"
    debian8.vm.box_download_checksum_type = "sha256"
  end
  config.vm.define "centos6" do |centos6|
    centos6.vm.box = "adsy-centos-6.5.box"
    centos6.vm.box_url = "https://pkg.adfinis-sygroup.ch/vagrant/adsy-centos-6.5.box"
    centos6.vm.box_download_checksum = "a0f2cc25560495cd927da103659a59d69b2e4f1bf032ee67f35e8ea1b1c88a80"
    centos6.vm.box_download_checksum_type = "sha256"
    centos6.ssh.insert_key = false
  end
  config.vm.define "centos7" do |centos7|
    centos7.vm.box = "adsy-centos-7.2.box"
    centos7.vm.box_url = "https://pkg.adfinis-sygroup.ch/vagrant/adsy-centos-7.2.box"
    centos7.vm.box_download_checksum = "b7464b893efeec591e04b3f74adbdd6c2df2c5f044c1c38abfb014b3659e28a6"
    centos7.vm.box_download_checksum_type = "sha256"
    centos7.ssh.insert_key = false
  end
  config.vm.define "ubuntu14" do |ubuntu14|
    ubuntu14.vm.box = "adsy-ubuntu-14.04.box"
    ubuntu14.vm.box_url = "https://pkg.adfinis-sygroup.ch/vagrant/adsy-ubuntu-14.04.box"
    ubuntu14.vm.box_download_checksum = "a2dbf07b02f95e1c5b2579ccb2bdb2e0138787ead11bcd0c1e29931822039510"
    ubuntu14.vm.box_download_checksum_type = "sha256"
  end
  config.vm.define "ubuntu16" do |ubuntu16|
    ubuntu16.vm.box = "adsy-ubuntu-16.04.box"
    ubuntu16.vm.box_url = "https://pkg.adfinis-sygroup.ch/vagrant/adsy-ubuntu-16.04.box"
    ubuntu16.vm.box_download_checksum = "bf80309862a07be833bde34474ac235510c346d6689ad8df90104eecc4c1743b"
    ubuntu16.vm.box_download_checksum_type = "sha256"
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

  #config.vm.provision "shell", inline: <<-SHELL
  #  apt-get update
  #  apt-get install -y apache2
  #SHELL
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "./site.yml"
    ansible.sudo = true
    ansible.extra_vars = {
      ansible_ssh_user: 'vagrant',
      ansible_managed: 'Warning: File is managed by Ansible [https://git.adfinis-sygroup.ch/ad-sy/ansible-roles.src]',
    }
  end
end
