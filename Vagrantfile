# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION ||= "2"

ENV['VAGRANT_DEFAULT_PROVIDER'] = "virtualbox"

confDir = $confDir ||= File.expand_path(File.dirname(__FILE__))
settingsPath = confDir + "/settings.yml"

require File.expand_path(File.dirname(__FILE__) + '/scripts/peon.rb')

Vagrant.require_version '>= 1.9.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if File.exist? settingsPath then
    settings = YAML::load(File.read(settingsPath))
  else
    abort "'settings.yml' file not found in #{confDir}."
  end

  config.vm.define "peon-devops"
  config.vm.box = "centos/7"
  config.vm.box_check_update = true
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.ssh.forward_agent = true
  config.vm.network :private_network, ip: "192.168.33.10"  

  config.vm.provision "shell" do |s|
    s.name = "Install Ansible"
    s.path = "./scripts/ansible-install.sh"
    s.args = "2.6.1"
  end

  config.vm.provision "shell" do |s|
    s.name = "Execute Ansible Playbook"
    s.inline = "ansible-playbook /vagrant/ansible/playbook.yml -i \"localhost,\" -c local"
  end

  Peon.work(config, settings)
end
