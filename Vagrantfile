# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION ||= "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "peon-devops"
  config.vm.box = "centos/7"
  config.vm.box_check_update = true
  config.ssh.forward_agent = true
  config.vm.network :private_network, ip: "192.168.33.10"

  config.vm.provider "virtualbox" do |vb|
    required_plugins = %w(vagrant-vbguest vagrant-disksize)
    required_plugins.each do |plugin|
      unless Vagrant.has_plugin? plugin
        system "vagrant plugin install #{plugin}"
        _retry=true
      end
    end

    config.vbguest.auto_update = true
    config.disksize.size = "40GB"

    vb.name = "peon-devops"
    vb.linked_clone = true
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--cpus", "1"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end

  config.vm.provision "ansible_local" do |ansible|
      ansible.version = "2.6.1"
      ansible.playbook = "./ansible/playbook.yml"
  end
end
