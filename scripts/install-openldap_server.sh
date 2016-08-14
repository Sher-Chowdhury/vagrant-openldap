#!/bin/bash

echo '##########################################################################'
echo '##### About to run install-openldap_server.sh script #####################'
echo '##########################################################################'


yum install -y openldap openldap-clients openldap-servers

# migration tools is optional
# it is a quick way to create ldap accounts from an existing /etc/passwd file
yum install -y migrationtools



cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG

## The following command:
slaptest  2>/dev/null
## will output something like this:
# 5793304d hdb_db_open: database "dc=my-domain,dc=com": db_open(/var/lib/ldap/id2entry.bdb) failed: No such file or directory (2).
# 5793304d backend_startup_one (type=hdb, suffix="dc=my-domain,dc=com"): bi_db_open failed! (2)
# slap_startup failed (test would succeed using the -u switch)
## This is as expected at this stage
## running this command also ends up creating:

#[root@openldap-server ldap]# pwd
#/var/lib/ldap
#[root@openldap-server ldap]# ll
#total 18996
#-rw-r--r--. 1 root root     2048 Jul 23 09:52 alock               # this one
#-rw-------. 1 root root  2351104 Jul 23 09:52 __db.001            # this one
#-rw-------. 1 root root 17457152 Jul 23 09:52 __db.002            # this one
#-rw-------. 1 root root  1884160 Jul 23 09:52 __db.003            # this one
#-rw-r--r--. 1 root root      845 Jul 23 09:51 DB_CONFIG

# These are the database files and needs to be owned by the ldap user:

chown ldap:ldap /var/lib/ldap/*

# Now we start the ldap service:

systemctl start slapd
systemctl enable slapd
systemctl status slapd

The ldap service should be listening on port 389, on both ipv4 and ipv6
ss -atn | grep 389

# The following directory contains a list of schema file. Each schema defines a type of object that can be created in our ldap server
cd /etc/openldap/schema/

# We therefore have to load some of these schemas into ldap, as way to tell ldap what type of objects it can create/store

# Lets load in the first one:

ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f cosine.ldif

## Note: ldapi is left blank, which ldapadd assumes to mean localhost
## we are using the 'config' user's contect to load in the schema, cosine.ldif

## output is someting like:

#SASL/EXTERNAL authentication started
#SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
#SASL SSF: 0
#adding new entry "cn=cosine,cn=schema,cn=config"

# Next we do:

ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f nis.ldif


cd /tmp/openldap

# Now let's create an ldap root password:

slappasswd -s password123 -n > rootpwd    # the -n option trims out the trailing return key character

cat rootpwd


sed -i -e "s:xxxxxxxxxx:`cat /tmp/openldap/rootpwd`:g" config.ldif

ldapmodify -Y EXTERNAL -H ldapi:/// -f config.ldif

# The output from the above command should be something like:


# SASL/EXTERNAL authentication started
# SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
# SASL SSF: 0
# modifying entry "olcDatabase={2}hdb,cn=config"
#
# modifying entry "olcDatabase={2}hdb,cn=config"
#
# modifying entry "olcDatabase={2}hdb,cn=config"
#
# modifying entry "cn=config"
#
# modifying entry "olcDatabase={1}monitor,cn=config"

cd /tmp/openldap
ldapadd -x -w password123 -D "cn=Manager,dc=openldap-server,dc=local" -f structure.ldif

## This should output:

# adding new entry "dc=openldap-server,dc=local"
#
# adding new entry "ou=people,dc=openldap-server,dc=local"
#
# adding new entry "ou=group,dc=openldap-server,dc=local"



## The following command is to check that the above command worked:
ldapsearch -x -w password123 -D "cn=Manager,dc=openldap-server,dc=local" -b "dc=openldap-server,dc=local" -s sub "(objectclass=organizationalUnit)"

## This should output something like this

# # extended LDIF
# #
# # LDAPv3
# # base <dc=openldap-server,dc=local> with scope subtree
# # filter: (objectclass=organizationalUnit)
# # requesting: ALL
# #
#
# # people, openldap-server.local
# dn: ou=people,dc=openldap-server,dc=local
# ou: people
# objectClass: top
# objectClass: organizationalUnit
#
# # group, openldap-server.local
# dn: ou=group,dc=openldap-server,dc=local
# ou: group
# objectClass: top
# objectClass: organizationalUnit
#
# # search result
# search: 2
# result: 0 Success
#
# # numResponses: 3
# # numEntries: 2


ldapadd -x -w password123 -D "cn=Manager,dc=openldap-server,dc=local" -f group.ldif

## The above command should output:

# adding new entry "cn=ldapusers,ou=group,dc=openldap-server,dc=local"


cd /tmp/openldap
#slappasswd -s passwordTOM -h {crypt} -n > toms-encrypted-password
#sed -i -e "s:xxxxxxxxxx:`cat /tmp/openldap/toms-encrypted-password`:g" user-tom.ldif
ldapadd -x -w password123 -D "cn=Manager,dc=openldap-server,dc=local" -f user-tom.ldif
ldappasswd -s testtom -w password123 -D "cn=Manager,dc=openldap-server,dc=local" -x "uid=tom,ou=people,dc=openldap-server,dc=local"



## The outputs:
# adding new entry "uid=tom,ou=People,dc=openldap-server,dc=local"

#slappasswd -s passwordJERRY -h {crypt} -n > jerrys-encrypted-password
#sed -i -e "s:xxxxxxxxxx:`cat /tmp/openldap/jerrys-encrypted-password`:g" user-jerry.ldif
ldapadd -x -w password123 -D "cn=Manager,dc=openldap-server,dc=local" -f user-jerry.ldif
ldappasswd -s testjerry -w password123 -D "cn=Manager,dc=openldap-server,dc=local" -x "uid=jerry,ou=people,dc=openldap-server,dc=local"



mkdir /etc/openldap-ssl-certs

openssl req -new -x509 -nodes -out /etc/openldap-ssl-certs/ldap.pem -keyout /etc/openldap-ssl-certs/ldapkey.pem -days 3650 -subj "/C=UK/ST=Hampshire/L=Southampton/O=CodingBee Ltd/OU=IT/CN=openldapmaster.openldap-server.local/emailAddress=webmaster@codingbee.net"

cd /tmp/openldap
ldapmodify -Y EXTERNAL -H ldapi:/// -f cert.ldif



sed -i -e 's|SLAPD_URLS="ldapi:/// ldap:///"|SLAPD_URLS="ldapi:/// ldap:/// ldaps:///"|g' /etc/sysconfig/slapd
systemctl restart slapd

ss -atn # should now be listening on port 636 (ldaps secure)

yum install -y httpd

cp /etc/openldap-ssl-certs/ldap.pem /var/www/html/ldap.pem

systemctl enable httpd
systemctl start httpd
