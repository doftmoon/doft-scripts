# -*- mode: ruby -*-
# vi: set ft=ruby :
# SPDX-License-Identifier: MIT
# Copyright (c) 2025 doftmoon

Vagrant.configure("2") do |config|

  config.vm.synced_folder ".", "/vagrant", disabled: false

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "2024"
    vb.cpus = 2
  end

  config.vm.define "arch" do |arch|
    arch.vm.box = "generic/arch"
    arch.vm.box_version = "4.3.12"

    arch.vm.hostname = "arch-test"

    arch.vm.provision "shell", inline: <<-SHELL
      sudo pacman -Syu --noconfirm
      sudo pacman -S --noconfirm git
    SHELL
  end

  config.vm.define "fedora" do |fedora|
    fedora.vm.box = "generic/fedora39"

    fedora.vm.hostname = "fedora-test"

    fedora.vm.provision "shell", inline: <<-SHELL
      sudo dnf update -y
    SHELL
  end

  config.vm.define "ubuntu" do |ub|
    ub.vm.box = "ubuntu/jammy64"

    ub.vm.hostname = "ubuntu-test"

    ub.vm.provision "shell", inline: <<-SHELL
      apt-get update

      # Install required packages
      apt-get install -y ca-certificates curl gnupg git

      # Add Docker's official GPG key
      install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      chmod a+r /etc/apt/keyrings/docker.gpg

      # Add Docker repository
      echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null

      # Install Docker packages
      apt-get update
      apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

      # Add vagrant user to docker group
      usermod -aG docker vagrant
    
      git clone https://github.com/doftmoon/doft-scripts.git
      chown vagrant:vagrant doft-scripts
    SHELL
  end
end
