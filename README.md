### Overview

This is a vagrant project that builds a 3 Centos7 VMs running on Virtualbox:  

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

Note, you only need to ssh into the openldap-client01 in order to practice for the RHCSA exam. To pracice for the RHCSA exam, you need to ssh into openldap-client01 and then install & configure the openldap client. Once that's done, you should then test if your openldap client is working as expected. We'll explain how to perform these tests later.  

### Pre-reqs

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



### Set up

From your macbook/laptop/desktop, open up a bash (or git-bash) terminal, cd into the directory that contains the file "Vagrantfile", then run:

```sh
$ vagrant up
```
Monitor output, there will be some texts that are highlighted in red. Review them to ensure that they're not error messages.


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

### Local Account Login credentials
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




#### openldap_server
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

#### nfs_server
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


#### openldap-client01 server

This vm is where you do all of your practicing for the RHCSA exam.

There are 2 ways to build this VM.

1. End-result state - This is the default state that is built when you ran the "vagrant up" command earlier on. In this mode, this vm has openldap and nfs clients already set up and in a working state. This will give you an idea of what to expect when everthing is working.
2. Vanilla state - In this state, openldap-client01 is just a generic centos7 machine and it's up to you to perform the tasks needed so that it mimicks the End-result state.






E.g. from your macbook/laptop/desktop, open up a bash (or git-bash) terminal, cd into the directory contains the file "Vagrantfile", then run:

```
ssh tom@192.168.52.101
```



### Auto snapshots

On accasions you'll want to reset your vagrant boxes. This is usually done by doing "vagrant destroy" followed by "vagrant up". This can be timeconsuming. A much faster approach is to use virtualbox snapshots instead.


For each vm, a virtualbox is taken towards the end of your "vagrant up". This snapshot is called "baseline". If you want to roll back to this snapshot, then you do:

```
vagrant snapshot go openldap-client01 baseline
```


### Start all over again
If you want to start from the begining again, then do:

```
vagrant destroy
vagrant box list
vagrant box remove {box name}
```

Then delete any .box files, or in fact delete the entire vagrant project then do a git clone again.  
