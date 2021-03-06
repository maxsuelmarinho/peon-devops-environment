class Peon
  def Peon.work(config, settings)

    scripts_home = File.dirname(__FILE__)

    instance_settings = settings["instance_settings"]

    config.vm.define "peon-devops"
    config.vm.box = instance_settings["box"]
    config.vm.box_check_update = true

    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
    config.ssh.forward_agent = true

    config.vm.provider "virtualbox" do |vb|
      required_plugins = %w(vagrant-vbguest vagrant-disksize)
      required_plugins.each do |plugin|
        unless Vagrant.has_plugin? plugin
          system "vagrant plugin install #{plugin}"
          _retry=true
        end
      end

      config.vbguest.auto_update = true

      vb.customize ["modifyvm", :id, "--memory", instance_settings["memory"] ||= "1024"]
      vb.customize ["modifyvm", :id, "--cpus", instance_settings["cpus"] ||= "1"]
      config.disksize.size = instance_settings["disk_size"] ||= "20GB"

      private_network_ip = "192.168.33.10"
      if instance_settings.include? "network"
        network_settings = instance_settings["network"]
        private_network_ip = network_settings["private_network_ip"]

        # Standardize Ports Naming Schema
        if network_settings.include? "ports"
          network_settings["ports"].each do |port|
            port["guest"] ||= port["to"]
            port["host"] ||= port["send"]
            port["protocol"] ||= "tcp"
          end
        else
          network_settings["ports"] = []
        end

        config.vm.network :private_network, ip: private_network_ip

        # Add Custom Ports From Configuration
        if network_settings.include? "ports"
          network_settings["ports"].each do |port|
            config.vm.network "forwarded_port", guest: port["guest"], host: port["host"], protocol: port["protocol"], auto_correct: true
          end
        end
      end

      vb.name = "peon-devops"
      vb.linked_clone = true
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    end

    if settings.include? "ssh_private_keys"
      settings["ssh_private_keys"].each do |key|
        config.vm.provision "shell" do |s|
          s.privileged = false
          s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
          s.args = [File.read(File.expand_path(key)), key.split("/").last]
        end
      end
    end

    if settings.include? 'shared_folders'
      settings["shared_folders"].each do |folder|
        if File.exists? File.expand_path(folder["src"])
          mount_opts = []

          if (folder["type"] == "nfs")
              mount_opts = folder["mount_options"] ? folder["mount_options"] : ['actimeo=1', 'nolock']
          elsif (folder["type"] == "smb")
              mount_opts = folder["mount_options"] ? folder["mount_options"] : ['vers=3.02', 'mfsymlinks']
          end

          options = (folder["options"] || {}).merge({ mount_options: mount_opts })
          options.keys.each{|k| options[k.to_sym] = options.delete(k) }

          config.vm.synced_folder folder["src"], folder["dest"], type: folder["type"] ||= nil, **options

          if Vagrant.has_plugin?("vagrant-bindfs")
              config.bindfs.bind_folder folder["dest"], folder["dest"]
          end
        else
          config.vm.provision "shell" do |s|
            s.inline = ">&2 echo \"Unable to mount folder: #{folder['src']}\""
          end
        end
      end
    end

    config.vm.provision "ansible_local" do |ansible|
      ansible.limit = "all"
      ansible.playbook = "ansible/playbook.yml"
      ansible.config_file = 'ansible/ansible.cfg'
      ansible.verbose = true # true, "vvv", or "vvvv"
    end

    #config.vm.provision "shell" do |s|
    #  s.name = "Install Ruby"
    #  s.path = scripts_home + "/ruby-install.sh"
    #  s.args = "2.5"
    #end

    #config.vm.provision "shell" do |s|
    #  s.name = "Install Snap"
    #  s.path = scripts_home + "/snapd-install.sh"
    #end

    if settings.include? "git"
      gitConfig = settings["git"]
      config.vm.provision "shell" do |s|
        s.privileged = false
        s.name = "Git Config"
        s.path = scripts_home + "/git-config.sh"
        s.args = [gitConfig["username"], gitConfig["email"]]
      end
    end

  end
end
