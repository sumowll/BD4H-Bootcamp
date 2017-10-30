---
layout: post
title: Environment Setup for Deep Learning
categories: [section]
navigation:
  section: [7, 1]
---

# Framework
## PyTorch
We will use ***[PyTorch](http://pytorch.org/)*** on Python 3.6 as our main deep learning framework for the lab sessions for now. Later, we may expand these lab sessions with other popular deep learning frameworks such as TensorFlow and Theano. Your helps for adopting other frameworks or for enriching the lab materials are always welcome!

## Jupyter Notebook
We will provide a Jupyter (iPython) Notebook file to practice some examples for each part of tutorials.

# Environment
<!--
## Docker
We have prepared a Docker image (***sorry for the additional environment, we have a plan to combine all into a single environment***) and you can start a instance by following commands (install Docker first if you did not.)

{% highlight bash %}
docker run -it --privileged=true --cap-add=SYS_ADMIN --name doctorai -p 2222:22 -p 9530:9530 -v /YOUR/LOCAL/FOLDER/TO/SHARE:/mnt/data yuikns/doctorai:latest /bin/bash
{% endhighlight %}
-->

<!--
## Azure Server
We prepared a server with a GPU on Microsoft Azure. It would be enough to follow just the lab sessions even though the server is not very powerful one.

### Access to the server
We created users and put the public keys same with the one you received from us to use our secure environment. You can access to this Azure server by using the `USERNAME` and the `PATH-TO-KEYFILE` with the following command:
 
```bash
ssh <USERNAME>@52.175.231.74 -i <PATH-TO-KEYFILE>
```
For example, if I received `p_san37` as my user name for the secure environment and my key file is located at `~/.ssh/cse6250-se`, then I can login to our Azure server also by:

```bash
ssh p_san37@52.175.231.74 -i ~/.ssh/cse6250-se
```
You can modify your ssh configuration file, `~/.ssh/config`, and add corresponding information for more convenient access.

### Configurations
#### Path
We already installed package required including Anaconda2/3, PyTorch, and CUDA libraries.
However, you need to set PATH for at least Anaconda executable files.
Therefore, once you successfully login to the server, please run the following command to set the path at the end of your `.bashrc` file:

```bash
echo 'export PATH=/usr/local/anaconda3/bin:$PATH' >> ~/.bashrc
```
or you can manually modify `~/.bashrc` file with your favorite editor, e.g. `vim`.

If you want to use Anaconda2 (Python 2.7), you can replace `anaconda3` in the command above with `anaconda2`. However, please note that the tutorial notebook files are written in Python 3 and you will need to modify codes.

#### Jupyter
If you want to directly run the tutorial notebook files, you need to run a Jupyter server first.
-->
## JupyterHub on Azure
We prepared a server with a GPU on Microsoft Azure. It would be enough to follow just the lab sessions even though the server is not very powerful one.

### Access to the server
You can directly access to the JupyterHub with pre-copied Notebooks used in entire lab sessions on your web browser. Please open your favorite web browser and move to the following address including the port number:

<a href='http://52.175.231.74:8000' target='_blank'>http://52.175.231.74:8000</a>

Then, you will meet the following login page.
![login]({{ site.baseurl }}/image/DL/login.png)

Please use `guest` for both Username and Password.
Once you successfully login with the guest account, you can find the folders
![jupyter]({{ site.baseurl }}/image/DL/jupyter.png)

- Deep Learning Labs
	- Notebook files used in the tutorial.
- Scratch Pads
	- Temporary folder for guests.

You can find the same notebook files used in the entire tutorials in `Deep Learning Labs` folder. Also, you can try to practice by yourself with creating a new file in `Scratch Pads` folder. Please note that we will clean up `Scratch Pads` folder occasionally without any notice.

## Native
You can also use your native local machine as your environment if you want to.

### Python Backend
We recommend you to use [Anaconda](https://anaconda.org/) for your Python backend (the tutorial notebooks are based on Python 3.6).

### GPU acceleration
If you have a proper NVIDIA GPU(s) and want to utilize it, install [CUDA Toolkit](https://developer.nvidia.com/cuda-downloads) (7.5 or 8.0) including [cuDNN](https://developer.nvidia.com/cudnn) before installing PyTorch.

### Install PyTorch
#### Linux
##### CUDA 8.0
```bash
conda install pytorch torchvision cuda80 -c soumith
```
##### CUDA 7.5
```bash
conda install pytorch torchvision -c soumith
```
#### Mac (OSX)
##### CPU Only
```bash
conda install pytorch torchvision -c soumith
```
Mac users who want to use your GPU, you will need to build PyTorch from the [source](https://github.com/pytorch/pytorch#from-source). Here is a good blog post about it ([link](https://zhaoyu.li/post/install-pytorch-on-mac-with-nvidia-gpu/)).

#### Windows
There is no official support for Windows yet, but for Anaconda3 on Windows x64 (Windows 10, Windows Server 2016) you can try:
```bash
conda install -c peterjc123 pytorch
```
If you have some troubles, please refer to this [pre-official discussion](https://github.com/pytorch/pytorch/issues/494). It seems it will be merged into the official version soon!

### Notebooks
If you want to download all notebook files to your local:
```
git clone https://github.com/ast0414/CSE6250BDH-LAB-DL.git
```

**For more details, please refer to the official homepage of [PyTorch](http://pytorch.org/).**
