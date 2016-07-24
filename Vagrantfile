# -*- mode: ruby -*-
# vi: set ft=ruby :


# http://stackoverflow.com/questions/19492738/demand-a-vagrant-plugin-within-the-vagrantfile
required_plugins = %w( vagrant-hosts vagrant-share vagrant-vbguest vagrant-vbox-snapshot vagrant-host-shell vagrant-triggers vagrant-reload )
plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end



Vagrant.configure(2) do |config|
  ##
  ##  openldap_server
  ##
  # The "openldap_server" string is the name of the box.
  config.vm.define "openldap_server" do |openldap_server_config|
    openldap_server_config.vm.box = "centos7.box"

    # this set's the machine's hostname.
    openldap_server_config.vm.hostname = "openldapmaster.openldap-server.local"          # underscore isnt allowed in vagrant.


    # This will appear when you do "ip addr show". You can then access your guest machine's website using "http://192.168.50.4"
    openldap_server_config.vm.network "private_network", ip: "192.168.52.100"
    # note: this approach assigns a reserved internal ip addresses, which virtualbox's builtin router then reroutes the traffic to,
    #see: https://en.wikipedia.org/wiki/Private_network

    openldap_server_config.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = false
      # For common vm settings, e.g. setting ram and cpu we use:
      vb.memory = "2048"
      vb.cpus = 2
      # However for more obscure virtualbox specific settings we fall back to virtualbox's "modifyvm" command:
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      # name of machine that appears on the vb console and vb consoles title.
      vb.name = "openldap_server"
    end

    openldap_server_config.vm.provision :host_shell do |host_shell|
      host_shell.inline = "cp -f ${HOME}/.gitconfig ./personal-data/.gitconfig"
    end

    openldap_server_config.vm.provision "shell" do |s|
      s.inline = '[ -f /vagrant/personal-data/.gitconfig ] && runuser -l vagrant -c "cp -f /vagrant/personal-data/.gitconfig ~"'
    end

    ## Copy the public+private keys from the host machine to the guest machine
    openldap_server_config.vm.provision :host_shell do |host_shell|
      host_shell.inline = "[ -f ${HOME}/.ssh/id_rsa ] && cp -f ${HOME}/.ssh/id_rsa* ./personal-data/"
    end
    openldap_server_config.vm.provision "shell", path: "scripts/import-ssh-keys.sh"

    openldap_server_config.vm.provision "file", source: "files/openldap", destination: "/tmp"

    openldap_server_config.vm.provision "shell", path: "scripts/install-openldap_server.sh"

    # this takes a vm snapshot (which we have called "basline") as the last step of "vagrant up".
    openldap_server_config.vm.provision :host_shell do |host_shell|
      host_shell.inline = 'vagrant snapshot take openldap_server baseline'
    end

  end

  ##
  ## openldap-client - linux 7 boxes
  ##
##  (1..2).each do |i|
  (1..1).each do |i|
    config.vm.define "openldap-client0#{i}" do |openldap_client|
      openldap_client.vm.box = "centos7.box"
      openldap_client.vm.hostname = "openldap-client0#{i}.local"
      openldap_client.vm.network "private_network", ip: "192.168.52.10#{i}"
      openldap_client.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.memory = "1024"
        vb.cpus = 1
        vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
        vb.name = "openldap-client0#{i}"
      end

      openldap_client.vm.provision "shell", path: "scripts/install-openldap_client.sh"

      # this takes a vm snapshot (which we have called "basline") as the last step of "vagrant up".
      openldap_client.vm.provision :host_shell do |host_shell|
        host_shell.inline = "vagrant snapshot take openldap-client0#{i} baseline"
      end

    end
  end

  # this line relates to the vagrant-hosts plugin, https://github.com/oscar-stack/vagrant-hosts
  # it adds entry to the /etc/hosts file.
  # this block is placed outside the define blocks so that it gts applied to all VMs that are defined in this vagrantfile.
  config.vm.provision :hosts do |provisioner|
    provisioner.add_host '192.168.52.100', ['openldapmaster', 'openldapmaster.openldap-server.local']
    provisioner.add_host '192.168.52.101', ['openldap-client01', 'openldap-client01.local']
    provisioner.add_host '192.168.52.102', ['openldap-client02', 'openldap-client02.local']
  end

  config.vm.provision :host_shell do |host_shell|
    host_shell.inline = 'hostfile=/c/Windows/System32/drivers/etc/hosts && grep -q 192.168.52.100 $hostfile || echo "192.168.50.100   openldap_server openldap_server.local" >> $hostfile'
  end

  config.vm.provision :host_shell do |host_shell|
    host_shell.inline = 'hostfile=/c/Windows/System32/drivers/etc/hosts && grep -q 192.168.52.101 $hostfile || echo "192.168.50.101   openldap-client01 openldap-client01.local" >> $hostfile'
  end

  config.vm.provision :host_shell do |host_shell|
    host_shell.inline = 'hostfile=/c/Windows/System32/drivers/etc/hosts && grep -q 192.168.52.102 $hostfile || echo "192.168.50.102   openldap-client02 openldap-client02.local" >> $hostfile'
  end
end
