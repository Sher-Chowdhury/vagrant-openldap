#!/bin/bash
# this script is run on the agent only. 

rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm || exit 1
yum install -y puppet-agent || exit 1


echo "PATH=$PATH:/opt/puppetlabs/bin" >> /root/.bashrc || exit 1
PATH=$PATH:/opt/puppetlabs/bin || exit 1



#echo "    certname          = `hostname --fqdn`" >> /etc/puppet/puppet.conf
#echo "    server            = puppetmaster.local" >> /etc/puppet/puppet.conf


ping -c 3 puppetmaster.local
if [ $? -eq 0 ]; then
  puppet agent -t  2>/dev/null
  puppet agent -t
fi
