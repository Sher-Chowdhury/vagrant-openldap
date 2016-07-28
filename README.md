vagrant-ansible

### Overview

This is a combined packer+vagrant project. The packer side outputs .box files which are then fed into the vagrant code. The vagrant project is a 3 Centos 7 vm development environment, i.e.:  

```
$ vagrant status
Current machine states:

openldap_server           not created (virtualbox)
openldap_client01         not created (virtualbox)
openldap_client02         not created (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

Here we have the openldap_server vm, this has the openldap_server packages installed. openldap_client01 and 02 are just Centos 7 installs with the openldap client package installed.  


### Pre-reqs

you need to have the following installed on your host machine:

* [virtualbox](https://www.virtualbox.org/)  
* [packer](https://www.packer.io/)
* [vagrant](https://www.vagrantup.com/)
* [git-bash](https://msysgit.github.io/) # Note: note required for Apple Mac users. 

Once they are all installed, do the following (note, note required for Apple Mac users):

1. right click on the virtualbox icon,
2. go to properties,
3. select the shortcut tab
4. click on the "advanced" button
5. enable the "Run as Administrator" checkbox
6. Then apply and save changes
7. Repeat the above steps, but this time for Git bash, You can find this icon under, start -> All programs -> git -> Git Bash


Next we need to configure Git bash to make it easier to use (Note, note required for Apple Mac users):

1. Open new git bash tereminal
2. right click on the header -> defaults -> "Options" tab -> enable check boxes (there's four in total)
3. Select the "Layout" tab
4. Adjust screen/window sizes according to your liking. Also choose a high number for the "Height" option under "screen buffer size", e.g. 5000.
5. Close git bash terminal, then reopen it again.
6. Right click on the header -> properties.
7. View the necessary tabs to ensure that your changes are now reflected.   

This will allow you to scroll up further and do copy-pasting in/out of the git-bash terminal more easily.  




### Set up

Start a git-bash or bash terminal

cd into the project folder and run the following to create the 2 ".box"" files

```sh
$ packer build centos7.json 
```
This will take about 20 minutes to complete, but depends on your machine specs and internet connections.

Then run the following:

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

You can now ssh into each vm like this:

```
$ vagrant ssh openldap-client01
```

For the RHCSA exam, you only need to know how to setup/configure openldap-client01



### Login credentials
You can also ssh into all your machines using:

```
username: vagrant
password: vagrant
```

or:

```
username: root
password: vagrant
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
