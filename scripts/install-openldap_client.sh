#!/bin/bash

echo '##########################################################################'
echo '##### About to run install-openldap_client.sh script #####################'
echo '##########################################################################'

# The following is optional for auto generating home directories, if you're not using centralised virtual nfs/cifs folders.
# yum install -y oddjob oddjob-mkhomedir


yum install -y openldap-clients nss-pam-ldapd

# They're are a few way to configure the client:
# authconfig-tui command
# authconfig-gtk command
# authconfig cli command
# realmd

# We are going to do it using the authconfig cli command

authconfig --enableldap --enableldapauth --ldapserver=openldapmaster.openldap-server.local --ldapbasedn="dc=openldap-server,dc=local" --update

sed -i -e 's/^passwd.*sss$/passwd:     files sss ldap/g' /etc/nsswitch.conf
sed -i -e 's/^shadow.*sss$/shadow:     files sss ldap/g' /etc/nsswitch.conf
sed -i -e 's/^group.*sss$/group:     files sss ldap/g' /etc/nsswitch.conf


systemctl start nslcd
systemctl enable nslcd


# There are two tests we can do to check if all the above has worked
ldapsearch -x
getent passwd
