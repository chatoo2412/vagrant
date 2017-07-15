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
		config.vm.synced_folder i["src"], "/vboxsf#{i["dest"]}"

		config.vm.synced_folder i["src"], i["dest"], type: :rsync,
			rsync__args: ["--verbose", "--archive"],
			rsync__exclude: i["rsync__exclude"]
	end

	# Copy the SSH private key
	config.vm.provision "copy_key", type: :file, source: "~/.ssh/id_rsa", destination: "~/id_rsa"

	# Configure the SSH private key
	config.vm.provision "set_key", type: :shell do |s|
		s.privileged = false
		s.inline = <<-EOF
			rm -f ~/.ssh/id_rsa
			mv ~/id_rsa ~/.ssh/
			chmod 400 ~/.ssh/id_rsa
		EOF
	end

	# Update APT repositories
	config.vm.provision "repo", type: :shell do |s|
		s.inline = <<-EOF
			add-apt-repository ppa:git-core/ppa -y
			apt-get update
			apt-get dist-upgrade -y
		EOF
	end

	# Install essential packages
	config.vm.provision "essential", type: :shell do |s|
		s.inline = <<-EOF
			apt-get install build-essential htop -y
		EOF
	end

	# Install and configure Git
	config.vm.provision "git", type: :shell do |s|
		s.privileged = false
		s.inline = <<-EOF
			sudo apt-get install git -y

			git config --global diff.compactionHeuristic true

			sudo chmod +x /usr/share/doc/git/contrib/diff-highlight/diff-highlight
			git config --global pager.log '/usr/share/doc/git/contrib/diff-highlight/diff-highlight | less'
			git config --global pager.show '/usr/share/doc/git/contrib/diff-highlight/diff-highlight | less'
			git config --global pager.diff '/usr/share/doc/git/contrib/diff-highlight/diff-highlight | less'
			git config --global interactive.diffFilter /usr/share/doc/git/contrib/diff-highlight/diff-highlight
		EOF
	end

	config.vm.provision :docker
	config.vm.provision :docker_compose,
		yml: "/vagrant/docker-compose.yaml",
		run: "always"

	# Install and configure ZSH
	config.vm.provision "zsh", run: "never", type: :shell do |s|
		s.privileged = false
		s.path = "zsh.sh"
	end
end
