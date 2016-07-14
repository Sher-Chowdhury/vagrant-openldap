#!/bin/bash

gem source https://rubygems.org    || exit 1

gem install r10k --no-ri --no-rdoc  || exit 1
# https://github.com/puppetlabs/r10k/blob/master/doc/dynamic-environments/configuration.mkd#automatic-configuration
mkdir -p /etc/puppetlabs/r10k || exit 1
echo "PATH=$PATH:/usr/local/bin" >> /root/.bashrc || exit 1       # this is where r10k is executable is stored. 



exit 0




#gem install bundler --no-ri --no-rdoc
#gem install rake --no-ri --no-rdoc


# Installing rvm for the vagrant user
runuser -l vagrant -c 'gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
runuser -l vagrant -c 'curl -sSL https://get.rvm.io | bash -s stable --ruby'
runuser -l vagrant -c 'rvm install 2.0.0'  
# runuser -l vagrant -c 'rvm install 1.9.3'
# runuser -l vagrant -c 'rvm install 1.8.7'
# runuser -l vagrant -c 'rvm install 2.2.3'
runuser -l vagrant -c 'rvm use --default 2.0.0'
runuser -l vagrant -c 'rvm all do gem install bundler'  
runuser -l vagrant -c 'rvm all do gem install json'          # required by vim plugins
runuser -l vagrant -c 'rvm all do gem install puppet-syntax' # required by vim plugins
runuser -l vagrant -c 'rvm all do gem install puppet-lint'   # required by vim plugins



systemctl enable NetworkManager 

echo "rvm now setup, now about to do a reboot."
reboot
sleep 120

