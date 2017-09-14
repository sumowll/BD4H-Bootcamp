---
layout: post
title: Deep Learning for Healthcare
categories: [section]
navigation:
  section: [7, 1]
---

# ---ALPHA TEST---

Deep learning techniques are widely used in many domains such as Computer Vision, Natural Language Processing, and Speech Recognition, etc. and have shown their great performances. Deep learning techniques have been applied for healthcare applications also and have achieved successes <sup id="a1">[1](#f1)</sup> <sup id="a2">[2](#f2)</sup>, even though there are some challenges different from other areas. 

Throughout the series of lab sessions, we will introduce some deep learning approches, a varity of neural networks, and practices on them. Enjoy!

## Framework
We will use ***[PyTorch](http://pytorch.org/)*** on Python 3.6 as our main deep learning framework for the lab sessions for now. Later, we may expand these lab sessions with other popular deep learning frameworks such as TensorFlow and Theano. Your helps for adopting other frameworks or for enriching the lab materials are always welcome!

## Environment
We have prepared a Docker image (***sorry for the additional environment, we have a plan to combine all into a single environment***) and you can start a instance by following commands (install Docker first if you did not.)

*Unix*

```
docker run -it --privileged=true --cap-add=SYS_ADMIN --name doctorai -p 2222:22 -p 9530:9530 -v /YOUR/LOCAL/FOLDER/TO/SHARE:/mnt/data yuikns/doctorai:latest /bin/bash
```

*Windows*

```
SOME COMMANDS
```

### Naive Local
You can also use your naive local machine as your environment if you want to. We recommend to use [Anaconda](https://anaconda.org/) for your Python backend (you can use python 2 or 3 based on your preference.) Also, install [CUDA Toolkit](https://developer.nvidia.com/cuda-downloads) (7.5 or 8.0) including [cuDNN](https://developer.nvidia.com/cudnn) if you have a proper NVIDIA GPU(s). Then, follow the instruction from the official page to install [PyTorch](http://pytorch.org/). *Mac* users who want to use your GPU, you will need to install PyTorch from [source](https://github.com/pytorch/pytorch#from-source). *Windows* users, there is no official support for Windows yet, but please try to this [pre-official discussion](https://github.com/pytorch/pytorch/issues/494).

We will provide a Notebook file (Jupyter and Zeppelin) for each part.

<b id="f1">1</b> Reference 1. [↩](#a1)

<b id="f2">2</b> Reference 2. [↩](#a2)