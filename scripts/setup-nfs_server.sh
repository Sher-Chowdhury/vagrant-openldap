#!/bin/bash

echo '##########################################################################'
echo '############ About to run setup-nfs_server.sh script #####################'
echo '##########################################################################'


yum install -y nfs-utils


mkdir -p /nfs/home-directories
chmod -R 777 /nfs/home-directories

mkdir /nfs/home-directories/tom
mkdir /nfs/home-directories/jerry

echo "hello tom" > /nfs/home-directories/tom/how-to-catch-a-mouse.txt

echo "hello jerry" > /nfs/home-directories/jerry/how-to-trick-a-cat.txt

#echo "/nfs/home-directories/tom        -rw        *" >  /etc/exports
#echo "/nfs/home-directories/jerry      -rw        *" >> /etc/exports

chown -R tom:ldapusers /nfs/home-directories/tom
chown -R jerry:ldapusers /nfs/home-directories/jerry
chmod 700 /nfs/home-directories/*
#echo "/nfs/home-directories     openldap-client01.local(rw,no_root_squash,no_all_squash)" >> /etc/exports
echo "/nfs/home-directories     openldap-client01.local(rw)" >> /etc/exports

systemctl enable nfs-server
systemctl restart nfs-server
