require "yaml"

conf = YAML.load_file(File.join(__dir__, "config.yaml"))

Vagrant.configure("2") do |config|
	config.vm.box = "ubuntu/trusty64"
	config.vm.hostname = "projects"

	config.vm.synced_folder "../../" "/projects"

	config.vm.provider provider do |v|
		v.name = "projects"
		v.cpus = 4
		v.memory = 4096
	end

	config.vm.provision "Copy the SSH private key", type: :file, source: "~/.ssh/id_rsa", destination: ".ssh/id_rsa"
	config.vm.provision "Configure the SSH private key", type: :shell do |s|
		s.privileged = false
		s.inline = <<-SHELL
			chmod 400 ~/.ssh/id_rsa
		SHELL
	end

	config.vm.provision "Update APT repositories", type: :shell do |s|
		s.inline = <<-SHELL
			add-apt-repository ppa:git-core/ppa -y
			apt-get update
		SHELL
	end

	config.vm.provision "Install and configure Git", type: :shell do |s|
		s.privileged = false
		s.inline = <<-SHELL
			sudo apt-get install git -y

			sudo chmod +x /usr/share/doc/git/contrib/diff-highlight/diff-highlight
			git config --global diff.compactionHeuristic true
			git config --global pager.log '/usr/share/doc/git/contrib/diff-highlight/diff-highlight | less'
			git config --global pager.show '/usr/share/doc/git/contrib/diff-highlight/diff-highlight | less'
			git config --global pager.diff '/usr/share/doc/git/contrib/diff-highlight/diff-highlight | less'
			git config --global interactive.diffFilter /usr/share/doc/git/contrib/diff-highlight/diff-highlight
		SHELL
	end

	config.vm.provision "Install and configure ZSH", type: :shell do |s|
		s.privileged = false
		s.inline = <<-SHELL
			sudo apt-get install zsh -y

			sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

			git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

			sed -i 's/plugins=(git)/plugins=(zsh-syntax-highlighting git docker docker-compose)/g' ~/.zshrc
		SHELL
	end

	config.vm.provision :docker do |d|
		d.pull_images "postgres:9-alpine"
		d.pull_images "redis:3-alpine"

		d.run "postgres:9-alpine",
			args: "--name postgres -d -p 5432:5432"
		d.run "redis:3-alpine",
			args: "--name redis -d -p 6379:6379"
	end

	config.vm.provision :docker_compose

	config.vm.network :private_network, type: "dhcp"
	config.vm.network :public_network
end
