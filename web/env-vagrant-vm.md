---
layout: page
title: CentOS VM in VirtualBox with Vagrant
description: Georgia Tech big data bootcamp training material
---


# Pre-requisite

In order to use the Docker environment we provide, you will need two pre-requisite
1. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Vagrant](http://www.vagrantup.com/downloads.html)

Also, please make sure you have enough free memory (4GB) available.

{% msgwarning %}
For Windows Users: Install GIT bash for windows which include SSH for access to the VM.
{% endmsgwarning%}


# Settings
The settings for the Vagrant VM are located in *vagrantconfig.yaml*. You can tweak them as necessary, such as adjusting the *number_cpus* or *memory_size* settings, to improve the performance of your VM.

# Setup
With pre-requiste softwares properly installed, you could setup your Centos VM learning environment. Before you actually run commands, please make sure you have enough previlege. For example, virtual network adapter and network filesystem will be set up.

{% msgwarning %}
For Windows Users: You may need to configure line endings before running vagrant up so the VM is properly configured. You can do this as a gobal configuration with "git config --global core.autocrlf false", or only for a given repo by setting "* text eol=lf" in .gitattributes of that repo. Be sure to follow the directions for refreshing a repo after changing line endings, as documented [here](https://help.github.com/articles/dealing-with-line-endings/#refreshing-a-repository-after-changing-line-endings "Refreshing a repository after changing line endings").
{% endmsgwarning%}

Open a terminal and you need to

1. Navigate to *vm* folder.
2. Run `vagrant up` to provision and run the VM.

(Note that the first run of `vagrant up` may take a long time. Please be patient.)

###  For Windows Users

1. Install VirtualBox: https://www.virtualbox.org/wiki/Downloads (Windows hosts)
2. Install Vagrant: http://www.vagrantup.com/downloads.html (Windows)
3. Restart computer
4. Open Git Bash
5. Change directory to where git cloned the sample code
          Mine was in my home directory: `cd ~/bigdata-bootcamp/vm`
          Inside this folder is the necessary files for vagrant to provision and run the VM
6. Type: `vagrant up`, this might take a bit, so grab a cup of coffee
7. Type: `vagrant status`, you should see bigtop1 running(virtualbox)
8. Connect to the vm by typing: `vagrant ssh`
9. If you are in the vm, type exit or ctrl+D to exit out of ssh
10. Type: `vagrant halt` to stop the vm from running
11. Type: `vagrant destroy` to destroy the current container

Vagrant Cheatsheet (https://gist.github.com/wpscholar/a49594e2e2b918f4d0c4)


#### Common Errors

```
-bash-4.1$ hdfs dfs -mkdir /user/vagrant
: command not founddoop-env.sh: line 15:
: command not founddoop-env.sh: line 16:
: command not founddoop-env.sh: line 21:
....
mkdir: Call From bigtop1.vagrant/127.0.0.1 to bigtop1.vagrant:8020 failed on connection exception: java.net.ConnectException: Connection refused; 
	For more details see:http://wiki.apache.org/hadoop/...
```

If you see the above error, it means the sample code you cloned was not checked out as is, so delete the local clone and type: `git config --global core.autocrlf false`.  Then clone the project again by: `git clone https://bitbucket.org/realsunlab/bigdata-bootcamp.git`.

Now when you do vagrant up, the vm should configured correctly.

Another way to set autocrlf, but just for this project, is to run instead:

```
git clone https://bitbucket.org/realsunlab/bigdata-bootcamp.git --config core.autocrlf=false
```

###  For macOS Users

1. Make sure you download the VirtualBox and Vagrant as mentioned in the webpage before going to next step.

Besides of download the images from official sites, you can also install required packages using `brew cask`

```
$ brew cask install virtualbox
$ brew cask install vagrant
$ brew cask install vagrant-manager
```
 
2. cd to the directory where you want to put the bigdata-bootcamp folder

```
$ git clone https://bitbucket.org/realsunlab/bigdata-bootcamp.git
$ cd bigdata-bootcamp/vm
```

3. Please check your computer technical specifications. If your computer only has the 4G RAM overall like me, you may want to edit the vagrantconfig.yaml to reduce the memory you want to give to the virtual box. (I changed the number from 4096 to 2048 in the vagrantconfig.yaml file.) After finishing editing or you don’t need to edit if you have more than 4G RAM, you can use the below comment:

```
$ vagrant up
```

It will take some time to run, please be patient. You can leave your terminal running, listen to some music and relax. 

4. After finishing setting up the virtual environment, you can connect to your virtual box.

```
$ vagrant ssh
```

You will see

```
[vagrant@bigtop1 ~]$
```

which means you sucessfully connect.
 
5. After connecting with you virtual box, we need to install git:

```
$ sudo yum install git
$ git clone https://bitbucket.org/realsunlab/bigdata-bootcamp.git
```
 
Now, you have the bigdata-bootcamp folder in your virtualbox system.
You are all set to run the lab sessions.
If you want to disconnect with the vagrant ssh, use Ctrl+D to exit the vagrant connection

As reference, [here is a link](https://asciinema.org/a/138214) shows the progress of vagrant's starting up in macOS.

Hope this sharing help! If there is anything else you would like to add, please feel free to leave the message below to share, especially for window users because I am also a Mac guy. I am not sure if we are allowed to implement in different way, hope instructor or other TA could explain it. 


# Using Zeppelin in Vagrant

Please refer to [https://asciinema.org/a/138869](https://asciinema.org/a/138869) for a simple demo progress.

[here](https://github.com/yuikns/bigtop-scripts/blob/master/install-zeppelin.sh) is a script to make it easier to install zeppelin. This script will check your folder in **virtual machine**, if the directory `/usr/local/zeppelin` is not exists, it will download zeppelin-0.7.2 from official repository.

Because of zeppelin requires much more resources, you are supposed to update the `${bigdata-bootcamp}/vm/vagrantconfig.yaml`, and increase the value of `memory_size`.

Besides, you are also required to update `Vagrantfile`, and append one line as follow:

```
bigtop.vm.network :forwarded_port, guest: 8080, host: 10080
```

Don't Panic! Please just simply update your git repository using `git pull origin fall2017` in `${bigdata-bootcamp}`

And then, you can reload vagrant using `vagrant reload` in vm.

Enter the vm, you can type

```bash
curl -L https://goo.gl/5g79vJ | sudo bash
```

This command will install zeppelin and related interpreters.

Here are the related commands

```
sudo -u zeppelin /usr/local/zeppelin/bin/zeppelin-daemon.sh start # start zeppelin service
sudo -u zeppelin /usr/local/zeppelin/bin/zeppelin-daemon.sh stop  # stop zeppelin service
sudo -u zeppelin /usr/local/zeppelin/bin/zeppelin-daemon.sh status # check current status
```

Once you started your service, please check your log file "/usr/local/zeppelin/logs/*.log", it may seems as follow:

```
INFO [2017-09-20 00:39:32,023] ({main} Server.java[doStart]:327) - jetty-9.2.15.v20160210  # It may stuck here for a while, since it is loading interpreters
INFO [2017-09-20 00:42:17,357] ({main} StandardDescriptorProcessor.java[visitServlet]:297) - NO JSP Support for /, did not find org.eclipse.jetty.jsp.JettyJspServlet
WARN [2017-09-20 00:42:17,831] ({main} Helium.java[loadConf]:101) - /bootcamp/data/zeppelin-0.7.2-bin-all/conf/helium.json does not exists
WARN [2017-09-20 00:42:20,744] ({main} Interpreter.java[register]:406) - Static initialization is deprecated for interpreter sql, You should change it to use interpreter-setting.json in your jar or interpreter/{interpreter}/interpreter-setting.json
INFO [2017-09-20 00:42:29,173] ({main} ServerImpl.java[initDestination]:94) - Setting the server's publish address to be /
INFO [2017-09-20 00:42:30,354] ({main} ContextHandler.java[doStart]:744) - Started o.e.j.w.WebAppContext@4194e3ee{/,file:/bootcamp/data/zeppelin-0.7.2-bin-all/webapps/webapp/,AVAILABLE}{/bootcamp/data/zeppelin-0.7.2-bin-all/zeppelin-web-0.7.2.war}
INFO [2017-09-20 00:42:30,364] ({main} AbstractConnector.java[doStart]:266) - Started ServerConnector@386d562{HTTP/1.1}{0.0.0.0:8080}
INFO [2017-09-20 00:42:30,365] ({main} Server.java[doStart]:379) - Started @179820ms
INFO [2017-09-20 00:42:30,365] ({main} ZeppelinServer.java[main]:194) - Done, zeppelin server started # This log means the the zeppelin server is ready now
```

After the service is ready, you can visit your browser using url "localhost:10080"

If you are facing any problem, please attach the related dump and log files, which could be found in `/usr/local/zeppelin/logs`.


# Related Vagrant Operations

You could connect to master node by run `vagrant ssh` in `vm` folder. You will find all materials in `/bootcamp` folder.

After you finish, you may want to terminate the virtual cluster. You could achieve that by

1. Navigate to *vm* folder.
2. Run `vagrant destroy -f` to destroy the VM.

Alternatively, you may just perform a graceful shutdown (without removing all traces of the virtual machine like above) by
1. Navigate to *vm* folder.
2. Run `vagrant halt` to gracefully shutdown the VM.
