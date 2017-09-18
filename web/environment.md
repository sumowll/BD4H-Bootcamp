---
layout: page
title: Learning Environment
description: Georgia Tech big data bootcamp training material
---

This section will show you how to setup environment. Setting up Hadoop, Spark, Java, etc. for a learning can be time consuming and tedious. In order to simplify this, we provide several different approaches. 

# Preliminary steps 

## Using  Terminal
In this training, we reply heavily on terminal.

- For *Linux* users, you are probably familiar with the terminal.
- For  *Mac* users, you could search for the `terminal` application if you have never use that before.
- For *Windows* users, please [install git](#install-git) and use the `Git Bash` application that comes with **Git for Windows**.

## Install Git
In order to get the latest sample source code, scripts for environment setup, you will need to install Git, a version control software.

### Install Git in Windows

Instruction:
http://www.sunlab.org/teaching/cse6250/fall2017/lab/environment/   course reference 
https://asciinema.org/a/137564     video reference by Yu

For Windows Guy/Gals:

Setup Git
1. Install Git: [https://git-scm.com/download/win](https://git-scm.com/download/win) . Please make sure you are installing this `Git for Windows`, instead of `Github for Windows` because you will rely heavily on `Git Bash` terminal. Make sure to install with **Checkout as-is**, **commit as-is**, otherwise you will run into errors for vagrant. If you have already installed git but wish to set autocrlf to false, type: `git config --global core.autocrlf false`, and then **re-clone** the git repository.
2. Open Git Bash
3. Decide where you want the sample code to live, I put mine in my home directory
4. Type: `git clone https://bitbucket.org/realsunlab/bigdata-bootcamp.git`

### Install Git in Mac
With Yosemite and higher, your OS comes preinstalled with git, so you do not need this step.
Otherwise, we highly recommend you install Git through [Homebrew](http://brew.sh). To do so, please

1. Open `Terminal`
2. Run `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
3. Run `brew install git`

### Install Git in Linux
Follow instructions in [Download for Linux and Unix](https://git-scm.com/download/linux).

# Download Samples

Please download sample code, data etc. from our bitbucket repository by issuing below command in a Terminal

```
git clone https://bitbucket.org/realsunlab/bigdata-bootcamp.git
```

# Setup Virtual Environment

We provide two simple approaches for environment setup, the 1st one is preferred.

1. [Centos in Vagrant]({{ site.baseurl }}/env-vagrant-vm)
2. [Docker in AWS EC2]({{ site.baseurl}}/env-aws-docker) (Alternative)
3. [Docker in Local OS (For Spark 2.0 or Jupyter/Zeppelin Notebook)]({{ site.baseurl }}/env-docker) (Alpha)
4.  [Docker in Azure]({{ site.baseurl}}/env-azure-docker) (Alternative)
