require "yaml"

conf = YAML.load_file(File.join(__dir__, "config.yaml"))

Vagrant.configure("2") do |config|
	conf["vm"].each do |k, v|
		config.vm.send("#{k}=", v)
	end

	config.vm.provider "virtualbox" do |v|
		v.name = conf["providers"]["virtualbox"]["name"]
		v.customize ["modifyvm", :id].concat(conf["providers"]["virtualbox"]["customize"])
	end

	config.vm.network :private_network, ip: conf["network"]["private_network"]["ip"]
	config.vm.network :public_network

	config.vm.synced_folder conf["path"]["src"], "/vboxsf#{conf["path"]["dest"]}"
	config.vm.synced_folder conf["path"]["src"], conf["path"]["dest"], type: :rsync,
		rsync__args: ["--verbose", "--archive"],
		rsync__exclude: conf["path"]["rsync__exclude"]

	config.timezone.value = conf["timezone"]

	config.vm.provision :docker
	config.vm.provision :docker_compose, run: "always",
		yml: "/vagrant/docker-compose.yaml"

	# Install and configure esstntial packages
	config.vm.provision "essential", type: :shell do |s|
		s.privileged = false
		s.path = "scripts/essential.sh"
		s.args = ["/usr/share/doc/git/contrib/diff-highlight/diff-highlight"]
	end

	# Install and configure ZSH
	config.vm.provision "zsh", type: :shell do |s|
		s.privileged = false
		s.path = "scripts/zsh.sh"
	end

	# Configure rsyarn
	config.vm.provision "rsyarn", type: :shell do |s|
		s.privileged = false
		s.inline = <<-EOF
			echo "" >> ~/.zshrc
			echo "# Environments" >> ~/.zshrc
			echo "export PATH=\\"/vagrant/scripts:\\$PATH\\"" >> ~/.zshrc
			echo "export RSYNCED=\\"#{conf["path"]["dest"]}\\"" >> ~/.zshrc
		EOF
	end
end
