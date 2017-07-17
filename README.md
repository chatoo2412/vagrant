# vagrant

Configure `Vagrantfile` by using your own yaml file.

This project also suggest a workaround for the [disk performance issue with VirtualBox shared folders](#disk-performance-issue-with-shared-folders).

## Prerequisites

* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox 5 or higher](https://www.virtualbox.org/) (This `Vagrantfile` uses new features in version 5.)

## Quick Start

```bash
$ cp config-example.yaml config.yaml
$ cp docker-compose-example.yaml docker-compose.yaml
$ cp scripts/zsh-example.sh scripts/zsh.sh
$ vagrant plugin install vagrant-timezone vagrant-docker-compose
$ vagrant up
$ vagrant provision --provision-with zsh
$ vagrant rsync-auto
```

## Caveats

### Disk performance issue with shared folders

#### Problem
VirtualBox shared folder(`/vboxsf/projects`) is extremely slow. It is highly recommended not to install npm packages or run node app under here.

#### Workaround
Instead, use `/projects` directory and `rsyarn` shell script.

* `/projects` directory: rsynced folder, native filesystem
* `rsyarn` shell script: alternative to `yarn`

#### See more
* http://stdout.in/en/post/increasing-vagrant-synced-folders-performance
* https://www.jeffgeerling.com/blogs/jeff-geerling/nfs-rsync-and-shared-folder
* https://medium.com/@dtinth/isolating-node-modules-in-vagrant-9e646067b36
* https://github.com/mitchellh/vagrant/issues/3062
