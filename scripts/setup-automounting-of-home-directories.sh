#!/bin/bash

echo '##########################################################################'
echo '### About to run setup-automounting-of-home-directories.sh script ########'
echo '##########################################################################'


yum install -y autofs

echo "/home/ldapusers   /etc/autofs/nfs/automount-home-directories.conf" >> /etc/auto.master
mkdir /home/ldapusers

mkdir -p /etc/autofs/nfs

echo "*  -fstype=nfs,rw  home-directories.nfs-server.local:/nfs/home-directories/&" > /etc/autofs/nfs/automount-home-directories.conf

systemctl start autofs
