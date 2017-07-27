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

	conf["synced_folders"].each do |i|
		config.vm.synced_folder i["src"], i["dest"]
	end

	config.timezone.value = conf["timezone"]

	config.vm.provision :docker
	config.vm.provision :docker_compose, run: "always",
		yml: "/vagrant/docker-compose.yaml"

	# Install and configure essential packages
	config.vm.provision "essential", type: :shell do |s|
		s.privileged = false
		s.path = "scripts/essential.sh"
		s.args = ["/usr/share/doc/git/contrib/diff-highlight/diff-highlight"]
	end

	# Install and configure shell
	config.vm.provision "shell", type: :shell do |s|
		s.privileged = false
		s.path = "scripts/shell.sh"
	end
end
