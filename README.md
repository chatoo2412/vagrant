# vagrant

Configure `Vagrantfile` by using your own yaml/sh files.

## Prerequisites

* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox 5 or higher](https://www.virtualbox.org/) (This `Vagrantfile` uses new features in version 5.)

## Quick Start

```bash
$ cp config-example.yaml config.yaml
$ cp docker-compose-example.yaml docker-compose.yaml
$ cp scripts/essential-example.sh scripts/essential.sh
$ cp scripts/shell-example.sh scripts/shell.sh
$ vagrant plugin install vagrant-timezone vagrant-docker-compose
$ vagrant up
```
