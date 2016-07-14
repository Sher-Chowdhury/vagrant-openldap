#!/bin/bash

echo '##########################################################################'
echo '##### About to run install-openldap_server.sh script #####################'
echo '##########################################################################'


yum install -y openldap openldap-clients openldap-servers

# migration tools is optional
yum install -y migrationtools
