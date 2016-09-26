---
layout: page
title: Learning Environment
description: Georgia Tech big data bootcamp training material
---

Setting up Hadoop, Spark, Java, etc. for a learning can be time consuming and tedious. In order to simplify this, we provide two different approaches. This section will show you how to setup environment.

# About Terminal
In this training, we reply heavily on terminal.

- For *Linux* users, you are probably familiar with the terminal.
- For  *Mac* users, you could search for the `terminal` application if you have never use that before.
- For *Windows* users, please [install git](#install-git) and use the `Git Bash` application that comes with **Git for Windows**.

# Install Git
In order to get the latest sample source code, scripts for environment setup, you will need to install Git, a version control software.

## Windows
Download and install Git from [https://git-scm.com/download/win](https://git-scm.com/download/win). Please make sure you are installing this `Git for Windows`, not  `Github for Windows` because you will rely heavily on `Git Bash` terminal.

## Mac
With Yosemite and higher, your OS comes preinstalled with git, so you do not need this step.
Otherwise, we highly recommend you install Git through Homebrew. To do so, please

1. Open `Terminal`
2. Run `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
3. Run `brew install git`

## Linux
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
2. [Docker in Local OS (For Spark 2.0 or Jupyter/Zeppelin Notebook)]({{ site.baseurl }}/env-docker) (Beta)
