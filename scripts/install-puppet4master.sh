#!/bin/bash

echo '##########################################################################'
echo '##### About to run install-puppetmaster4.sh script #######################'
echo '##########################################################################'


yum install -y ruby-devel   # this line is no longer required, so delete it since it has been added in the kickstart file.

# this is really important:
# http://docs.puppetlabs.com/puppet/4.3/reference/whered_it_go.html#new-codedir-holds-all-modulesmanifestsdata


# This shows the location of all the various puppet config files. 
# https://github.com/puppetlabs/puppet-specifications/blob/master/file_paths.md#puppetserver

# puppet.conf is now stored in /etc/puppetlabs/puppet/puppet.conf   
# This is specified here:
# http://docs.puppetlabs.com/puppet/4.3/reference/whered_it_go.html#nix-confdir-is-now-etcpuppetlabspuppet

# The environments folder (/etc/puppet/environment) is now located at: 
# http://docs.puppetlabs.com/puppet/4.3/reference/whered_it_go.html#new-codedir-holds-all-modulesmanifestsdata


rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm  || exit 1

yum install -y puppetserver || exit 1


# https://docs.puppetlabs.com/puppetserver/latest/install_from_packages.html#memory-allocation
sed -i s/^JAVA_ARGS/#JAVA_ARGS/g /etc/sysconfig/puppetserver || exit 1
#echo 'JAVA_ARGS="-Xms512m -Xmx512m -XX:MaxPermSize=256m"' >> /etc/sysconfig/puppetserver
echo 'JAVA_ARGS="-Xms512m -Xmx512m"' >> /etc/sysconfig/puppetserver || exit 1


# http://docs.puppetlabs.com/puppet/4.3/reference/whered_it_go.html
echo "PATH=$PATH:/opt/puppetlabs/bin" >> /root/.bashrc || exit 1
PATH=$PATH:/opt/puppetlabs/bin || exit 1
puppet --version || exit 1

# this is so to get the puppetmaster to autosign puppet agent certificicates. 
# This means that you no longer need to do "puppet cert sign...etc"
# https://docs.puppetlabs.com/puppet/latest/reference/ssl_autosign.html#basic-autosigning-autosignconf
# https://docs.puppetlabs.com/puppet/latest/reference/config_file_autosign.html

puppet config set autosign true --section master
# echo '*' >> /etc/puppet/autosign.conf   # this line needs fixing, see:
					  # https://docs.puppetlabs.com/puppet/latest/reference/config_file_autosign.html 


##
## The following is a direct copy taken from puppet 3.8 config file. So need to investigate which parts I need. 
##
## https://docs.puppetlabs.com/puppet/latest/reference/config_about_settings.html
## https://docs.puppetlabs.com/puppet/latest/reference/configuration.html
fqdn=`hostnamectl | grep 'Static hostname' | cut -d':' -f2`

puppet config set certname $fqdn --section agent 
puppet config set server $fqdn --section agent 

#echo '    certname          = puppet4master.local' >> /etc/puppetlabs/puppet/puppet.conf
#echo '    server            = puppet4master.local' >> /etc/puppetlabs/puppet/puppet.conf

systemctl enable puppetserver || exit 1
systemctl start puppetserver  || exit 1
systemctl restart puppetserver  || exit 1
systemctl status puppetserver || exit 1
