vagrant-ansible

### Overview

This is a combined packer+vagrant project. The packer side outputs .box files which are then fed into the vagrant code. The vagrant project is a 3 Centos 7 vm development environment, i.e.:  

```
$ vagrant status
Current machine states:

puppetmaster                not created (virtualbox)
puppetagent01           not created (virtualbox)
puppetagent02           not created (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

Here we have the puppetmaster vm, this has the free version of ansible installed. puppetagent01 and puppetagent02 are just Centos 7 installs. 

On the puppetmaster server, we have as user called "ansible":

```
[root@puppetmaster ~]# cat /etc/passwd | grep ansible
ansible:x:1001:1001::/home/ansible:/bin/bash
```


The environmeent is set up so that this "ansible" user can run ansible commands:

```
[ansible@puppetmaster ~]$ ansible --version
ansible 2.1.0 (devel 5cd3f71792) last updated 2016/02/02 22:03:51 (GMT +100)
  lib/ansible/modules/core: (detached HEAD 93d02189f6) last updated 2016/02/02 22:04:02 (GMT +100)
  lib/ansible/modules/extras: (detached HEAD fff5ae6994) last updated 2016/02/02 22:04:12 (GMT +100)
  config file =
  configured module search path = Default w/o overrides
``` 

Also notice that in this vagrant development environment, the version of ansible is v2.1.0.  


### Pre-reqs

you need to have the following installed on your host machine:

* [virtualbox](https://www.virtualbox.org/)  
* [packer](https://www.packer.io/)
* [vagrant](https://www.vagrantup.com/)
* [git-bash](https://msysgit.github.io/)

Once they are all installed, do the following:

1. right click on the virtualbox icon, 
2. go to properties, 
3. select the shortcut tab
4. click on the "advanced" button
5. enable the "Run as Administrator" checkbox
6. Then apply and save changes
7. Repeat the above steps, but this time for Git bash, You can find this icon under, start -> All programs -> git -> Git Bash 


Next we need to configure Git bash to make it easier to use:

1. Open new git bash tereminal
2. right click on the header -> defaults -> "Options" tab -> enable check boxes (there's four in total)
3. Select the "Layout" tab 
4. Adjust screen/window sizes according to your liking. Also choose a high number for the "Height" option under "screen buffer size", e.g. 5000. 
5. Close git bash terminal, then reopen it again. 
6. Right click on the header -> properties.
7. View the necessary tabs to ensure that your changes are now reflected.   

This will allow you to scroll up further and do copy-pasting in/out of the git-bash terminal more easily.  
 




### Pre-reqs (optional, but recommended)

Open up a git-bash terminal and: 

* run the ssh-keygen command on your host machine (if you haven't already done this in past). 
* run the following to enter your credentials (if you haven't already done this in past):

```
$ git config --global user.name "John Doe"
$ git config --global user.email johndoe@example.com
$ git config --global core.autocrlf false
$ git config --global push.default simple
```

On your (linux) host machine, create the following folder and add the following files:

```
$ ls -l /c/vagrant-personal-files/
total 1
drwxr-xr-x    4 SChowdhu Administ        0 Dec 21 14:20 GitServerCertificates
-rw-r--r--    1 SChowdhu Administ      210 Apr 20  2015 hiera.yaml
-rw-r--r--    1 SChowdhu Administ      291 Sep 30 08:52 r10k.yaml
```

However if your host machine is a windows machine, then create folder "C:\vagrant-personal-files" and place the above files in there instead. 

The "GitServerCertificates" folder should contain .pem files only, so that you can also do secure git clones inside your vm, i.e. "git clone https://..." as well as plain "git clone http://...". 



### Set up

Start a git-bash terminal

cd into the project folder and run the following to create the 2 ".box"" files

```sh
$ packer build puppetmaster.json
$ packer build client.json
```
Each of the above commands will take about 20 minutes to complete, but depends on your machine specs and internet connections. 

The Run the following:

```sh
$ vagrant up puppetmaster
``` 

There are also 2 ansible CentOS 7 clients that you can start up:


```sh
$ vagrant up puppetagent01
$ vagrant up puppetagent01
``` 



### Set up local rerouting if you are running vagrant on windows machine

Enter this in the windows hosts file (C:\Windows\System32\drivers\etc\hosts):

```
192.168.50.100   puppetmaster puppetmaster.local
192.168.50.101   puppetagent01 puppetagent01.local
192.168.50.102   puppetagent02 puppetagent02.local
```

### Login credentials
you can ssh into all your machines using:

```
username: vagrant 
password: vagrant
```

or:

```
username: root 
password: vagrant
```

If you want to trigger ansible runs, you need to log in as the root user. 




### Auto snapshots

On accasions you'll want to reset your vagrant boxes. This is usually done by doing "vagrant destroy" followed by "vagrant up". This can be timeconsuming. A much faster approach is to use virtualbox snapshots instead. 


For each vm, a virtualbox is taken towards the end of your "vagrant up". This snapshot is called "baseline". If you want to roll back to this snapshot, then you do:

```
vagrant snapshot go puppetmaster baseline
```

...or for an ansible client, e.g. puppetagent01, you do:

```
vagrant snapshot go puppetagent01 baseline
```



### Start all over again
If you want to start from the begining again, then do:

```
vagrant destroy
vagrant box list
vagrant box remove {box name}
```

Then delete the 2 .box files, or in fact delete the entire vagrant project then do a git clone again.  

