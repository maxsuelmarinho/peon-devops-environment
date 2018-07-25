class Peon
  def Peon.work(config, settings)

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
