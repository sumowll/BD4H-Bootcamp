---
layout: page
title: Learning Environment
description: Georgia Tech big data bootcamp training material
---

Setting up Hadoop, Spark, Java, Spark etc for learning could be time consuming and tedious. In order to simplify your work of setting up environment for learning, we provide two simple approaches. This section will show you how to setup environment.

# About Terminal
In this training, we reply heavily on terminal. 

- For *Linux* user, you may already very farmiliar wtih terminal. 
- For  *Mac* user, you could search the `terminal` application if you never use that before. 
- For *Windows* user, please [install git](#install-git) and use the  `Gi Bash` application come with **Git for Windows**.

# Install Git
In order to get lasted sample source code, scripts for environment setup, you will need to install Git, a version control software.

## Windows
Download and install Git from [https://git-scm.com/download/win](https://git-scm.com/download/win). Please make sure you are installing this `Git for Windows`, not  `Github for Windows` because you will rely heavily on `Git Bash` terminal.

## Mac
We highly recommend you install Git through Home brew. To do so, please

1. Open `Terminal`
2. Run `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
3. Run `bew install git`

## Linux
Follow instructions in [Download for Linux and Unix](https://git-scm.com/download/linux).

# Download Samples

Please download sample code, data etc. from our bitbucket repository by issueing below command in terminal

```
git clone git@bitbucket.org:realsunlab/bigdata-bootcamp.git
```

# Setup Virtual Environment

We provide two simple approaches for environment setup, the 1st one is prefered.

1. [Centos in Vagrant]({{ site.baseurl }}/env-vagrant-vm) (Suggested)
2. [Docker in CoreOS VM]({{ site.baseurl }}/env-docker)
