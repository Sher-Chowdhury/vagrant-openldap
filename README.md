# Overview

This is a vagrant project that builds 3 Centos7 VMs:  

```
$ vagrant status
Current machine states:

openldap_server           not created (virtualbox)
nfs_server                not created (virtualbox)
openldap-client01         not created (virtualbox)


This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

These 3 vms are all part of the same dedicated internal network and therefore can communicate with each other through the following ip addresses:

```
openldap_server           192.168.52.100
nfs_server                192.168.52.201
openldap-client01         192.168.52.101

```

Note, you only need to ssh into the openldap-client01 in order to practice for the RHCSA exam. To practice for the RHCSA exam, you need to ssh into openldap-client01 and then install & configure the openldap client. Once that's done, you should then test if your openldap client is working as expected. We'll explain how to perform these tests later.  

# Pre-reqs

you need to have the following installed on your host machine:

* [virtualbox](https://www.virtualbox.org/)  
* [vagrant](https://www.vagrantup.com/)
* [git-bash](https://msysgit.github.io/) # Note: This is not required for Apple Mac users.

Once they are all installed, do the following (note, not required for Apple Mac users):

1. right click on the virtualbox icon,
2. go to properties,
3. select the shortcut tab
4. click on the "advanced" button
5. enable the "Run as Administrator" checkbox
6. Then apply and save changes
7. Repeat the above steps, but this time for Git bash, You can find this icon under, start -> All programs -> git -> Git Bash


Next we need to configure Git bash to make it easier to use (Note, not required for Apple Mac users):

1. Open new git bash terminal
2. right click on the header -> defaults -> "Options" tab -> enable check boxes (there's four in total)
3. Select the "Layout" tab
4. Adjust screen/window sizes according to your liking. Also choose a high number for the "Height" option under "screen buffer size", e.g. 5000.
5. Close git bash terminal, then reopen it again.
6. Right click on the header -> properties.
7. View the necessary tabs to ensure that your changes are now reflected.   

This will allow you to scroll up further and do copy-pasting in/out of the git-bash terminal more easily.  



# Set up

From your macbook/laptop/desktop, open up a bash terminal (or git-bash for windows users), cd into the directory that contains the file "Vagrantfile", then run:

```sh
$ vagrant up
```

Note: this command might fail the first time, with only about 15 lines of output. If so then try a couple more times.  

Monitor the output, there will be some texts that are highlighted in red, which is expected. You just need to review them to ensure that they're not error messages.


Next confirm everything is running:

```
$ vagrant status
Current machine states:

openldap_server           running (virtualbox)
nfs_server                running (virtualbox)
openldap-client01         running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.

```

A gui window should have also opened up for the openldap-client01 only. That's so that you can use the authconfig-gtk tool's gui for configuring the openldap client.  


## Accessing your VMs
You can ssh into all your VMs using:

```
username: vagrant
password: vagrant
```

or:

```
username: root
password: vagrant
```

E.g. from your macbook/laptop/desktop, open up a bash (or git-bash) terminal, cd into the directory contains the file "Vagrantfile", then run:

```
ssh root@192.168.52.101
```

You can take the same approach for the vagrant user, however for the vagrant user there is special shorthand, which doesn't even prompt for a password:

```
$ vagrant ssh openldap-client01
```

Once your logged in as the vagrant user, you can then sudo into root by running "sudo -i".




# openldap_server
The openldap_server has the openldap server package installed and running. We have created 2 ldap based user accounts on the openldap_server, they are:

```
username: tom
password: testtom
```

and:

```
username: jerry
password: testjerry
```

For the RHCSA and RHCE exams you don't need to know how to set up an openldap_server like this. However it's worth exploring this VM for your own understanding.

# nfs_server
This nfs server has made two folders available to be accessible remotely.

```
codingbee@MacBook-Pro:~/git/vagrant-openldap$ vagrant ssh openldap-client01
Last login: Thu Aug 11 15:42:30 2016 from 10.0.2.2
[vagrant@openldap-client01 ~]$ showmount -e 192.168.52.201
Export list for 192.168.52.201:
/nfs/home-directories openldap-client01
[vagrant@openldap-client01 ~]$ exit
logout
Connection to 127.0.0.1 closed.
codingbee@Admins-MacBook-Pro:~/git/vagrant-openldap$ vagrant ssh nfs_server
Last login: Thu Aug 11 15:46:38 2016 from 10.0.2.2
[vagrant@home-directories ~]$ cd /nfs/home-directories
[vagrant@home-directories home-directories]$ ll
total 0
drwx------. 2 jerry ldapusers 35 Aug 11 14:01 jerry
drwx------. 4 tom   ldapusers 84 Aug 11 14:16 tom
[vagrant@home-directories home-directories]$ sudo tree .
.
├── jerry
│   └── how-to-trick-a-cat.txt
└── tom
    └── how-to-catch-a-mouse.txt

2 directories, 2 files
```

Here we can see the nfs_server has made 2 folders available that can be remotely accessible by other VMs. One folder is called "tom" and the other called "jerry". These folders are designed to act as centralised home directories for our ldap based users, tom and jerry, respectively.

The key benefit of having centralised home directories is that which server the user tom (or jerry) logs into, there home directories always has the same set's of files and folders.

For the RHCSA exam, you don't need to know how to setup + configure an nfs server like this. But you do for the RHCE exam.


# openldap-client01

This vm is where you do all of your practicing for the RHCSA exam.

There are 2 ways to build this VM.

1. End-result state (This is the default state)
2. Vanilla state

## End-result state
This is the default state that is built when you run "vagrant up". In this mode, this vm has openldap and nfs clients already set up, so that you can see what everything looks like when it is working. Heres a few things to check for:

1. Log into the openldap-client01 as the vagrant user:

```
$ vagrant ssh openldap-client01
```

2. Now view the passwd file:

```
$ cat /etc/passwd
```
Notice that there is no (local) usernames called "tom" or "jerry".

3. Now run:

```
$ getent passwd
```
This time you'll find both users, "tom" and "jerry" are now listed. This indicates that our vm is successfully communicating with openldap_server.

4. Another command that you can run to check that openldap-client01 is successfully communicating with openldap_server is:

```
$ ldapsearch -x
```

5. Now confirm that the following directory is empty:

```
$ cd /home/ldapusers/
$ ll
```
This is where nfs shares will get mounted when you ssh into this machine as an ldap user, i.e. in this case when you ssh into this machine as the user tom or jerry.

6. Now exit out of your vm, and this time try to login in again but this time as the user tom or jerry:

```
$ ssh tom@192.168.52.101
```
Enter the password when prompted.

7. At this point you should have successufully logged in:

```
$ $ ssh tom@192.168.52.101
Warning: Permanently added '192.168.52.101' (ECDSA) to the list of known hosts.
tom@192.168.52.101's password:
Permission denied, please try again.
tom@192.168.52.101's password:
Last failed login: Fri Aug 12 11:12:18 BST 2016 from 192.168.52.1 on ssh:notty
There was 1 failed login attempt since the last successful login.
Last login: Fri Aug 12 10:53:51 2016 from 192.168.52.1
```
Note, I intentionally entered an invalid password just to make sure password validation. If ldap isn't set up correctly then it is possible to login as an ldap user by entering an incorrect password.


8. Now let's check the details of the logged in user, to confirm that we are logged in as tom:

```
$ id
uid=4002(tom) gid=4000(ldapusers) groups=4000(ldapusers) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```

The fact that we have now managed to login using an ldap user means that ldap is working correctly. Now let's check if the nfs side of things are working.

9. Now let's check what is our current home directory, and what it contains:

```
$ pwd
/home/ldapusers/tom
$ ls -la
total 8
drwx------. 4 tom  ldapusers 84 Aug 12 09:46 .
drwxr-xr-x. 3 root root       0 Aug 12 10:53 ..
-rw-------. 1 tom  ldapusers 68 Aug 12 11:12 .bash_history
drwxr-xr-x. 3 tom  ldapusers 17 Aug 12 09:45 .cache
drwxr-xr-x. 3 tom  ldapusers 17 Aug 12 09:45 .config
-rw-r--r--. 1 tom  ldapusers 10 Aug 12 09:41 how-to-catch-a-mouse.txt
```

This directory didn't exist earlier, but thanks to autofs, it was automounted when you logged in as the ldap user. This folder is an nfs shared folder, which originates from the nfs_server. The fact that we can view it's content means that openldap-client01 is successfully communicating with the nfs service that's running on the nfs_server. Any files/folders that we edit/add/remove in this directory actually ends up happening on the nfs_server behind the scenes. Also since this directory doesn't actually exists on openldap-client01, it means that only the user "tom" can access this directory and no one else on openldap-client01, not even the root user:

```
$ vagrant ssh openldap-client01
Last login: Fri Aug 12 11:29:09 2016 from 10.0.2.2
[vagrant@openldap-client01 ~]$ sudo -i
[root@openldap-client01 ~]# cd /home/ldapusers/tom
-bash: cd: /home/ldapusers/tom: Permission denied
```

## Vanilla state
In this state, openldap-client01 is just a generic centos7 machine and it's up to you to perform the tasks needed so that it mimicks the End-result state.


To switch to the Vanilla state, we first need to destroy openldap-client01:

```
$ vagrant destroy openldap-client01
```

Now in your vagrant project folder, open the following file:

[Vagrantfile](https://github.com/Sher-Chowdhury/vagrant-openldap/blob/master/scripts/install-openldap_client.sh)

now in this file, search for the word 'vanilla', and then follow the instructions which indicates to comment out a couple of lines.

[./scripts/install-openldap_client.sh](https://github.com/Sher-Chowdhury/vagrant-openldap/blob/master/scripts/install-openldap_client.sh)


Next run:  

```
$ vagrant up openldap-client01
```

Now openldap-client01 is in vanilla mode. It is now up to you to manually perform the tasks to get openldap-client01 communicating with openldap_server
nfs_server again, like in the End-result state.

Note: to switch back to the End-result state again, just destroy openldap-client01 again, then comment out that line again, and then do a vagrant up again.


# Auto snapshots

On accasions you'll want to reset your vagrant boxes. This is usually done by doing "vagrant destroy" followed by "vagrant up". This can be timeconsuming. A much faster approach is to use virtualbox snapshots instead.


For each vm, a virtualbox is taken towards the end of your "vagrant up". This snapshot is called "baseline". If you want to roll back to this snapshot, then you do:

```
$ vagrant snapshot go openldap-client01 baseline
```

However it might be best to just destroy this vm and do vagrant up again.

# Start all over again
If you want to start from the beginning again, then do:

```
$ vagrant destroy
$ vagrant box remove --all
```

Then delete any .box files, or in fact delete the entire vagrant project then do a git clone again.  
