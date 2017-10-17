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

# Environment
## Docker
We have prepared a Docker image (***sorry for the additional environment, we have a plan to combine all into a single environment***) and you can start a instance by following commands (install Docker first if you did not.)

{% highlight bash %}
docker run -it --privileged=true --cap-add=SYS_ADMIN --name doctorai -p 2222:22 -p 9530:9530 -v /YOUR/LOCAL/FOLDER/TO/SHARE:/mnt/data yuikns/doctorai:latest /bin/bash
{% endhighlight %}

## Native
You can also use your native local machine as your environment if you want to. We recommend to use [Anaconda](https://anaconda.org/) for your Python backend (the tutorial notebooks are based on Python 3.6). Also, install [CUDA Toolkit](https://developer.nvidia.com/cuda-downloads) (7.5 or 8.0) including [cuDNN](https://developer.nvidia.com/cudnn) if you have a proper NVIDIA GPU(s). Then, follow the instruction from the official page to install [PyTorch](http://pytorch.org/). *Mac* users who want to use your GPU, you will need to install PyTorch from [source](https://github.com/pytorch/pytorch#from-source). *Windows* users, there is no official support for Windows yet, but please try to follow this [pre-official discussion](https://github.com/pytorch/pytorch/issues/494).

# Jupyter Notebook
We will provide a Jupyter (iPython) Notebook file to practice some examples for each part.