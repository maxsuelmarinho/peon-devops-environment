class Peon
  def Peon.work(config, settings)

    config.vm.provider "virtualbox" do |vb|
      required_plugins = %w(vagrant-vbguest vagrant-disksize)
      required_plugins.each do |plugin|
        unless Vagrant.has_plugin? plugin
          system "vagrant plugin install #{plugin}"
          _retry=true
        end
      end

      config.vbguest.auto_update = true

      if settings.include? 'instance_settings'
        instanceSettings = settings["instance_settings"]
        vb.customize ["modifyvm", :id, "--memory", instanceSettings["memory"] ||= "1024"]
        vb.customize ["modifyvm", :id, "--cpus", instanceSettings["cpus"] ||= "1"]
        config.disksize.size = instanceSettings["disk_size"] ||= "20GB"
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
          config.vm.synced_folder folder["src"], folder["dst"], type: folder["type"] ||= nil

          if Vagrant.has_plugin?("vagrant-bindfs")
              config.bindfs.bind_folder folder["to"], folder["to"]
          end
        else
          config.vm.provision "shell" do |s|
            s.inline = ">&2 echo \"Unable to mount folder: #{folder['src']}\""
          end
        end
      end
    end

  end
end
