# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION ||= "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "peon-devops"
  config.vm.box = "centos/7"
  config.vm.box_check_update = true
  config.ssh.forward_agent = true
  config.vm.network :private_network, ip: "192.168.33.10"

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = true
  end

  config.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "./ansible/playbook.yml"
  end
end
