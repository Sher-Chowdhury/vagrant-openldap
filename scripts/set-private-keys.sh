#!/bin/bash
if [ ! -d /home/vagrant/.ssh ]; then
  mkdir -p /home/vagrant/.ssh
  chown vagrant:vagrant /home/vagrant/.ssh
fi
if [ ! -f /home/vagrant/.ssh/authorized_keys ]; then
  wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys || exit 1
  chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys || exit 1
fi
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
