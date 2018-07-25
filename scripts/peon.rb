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
  end
end
