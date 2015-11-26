FROM bigtop/deploy:centos-6
MAINTAINER Hang Su "hangsu@gatech.edu"

RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo
RUN yum install -y sbt

# Install scala
RUN wget http://www.scala-lang.org/files/archive/scala-2.10.5.tgz
RUN tar xvf scala-2.10.5.tgz
RUN mv scala-2.10.5 /usr/lib
RUN ln -s /usr/lib/scala-2.10.5 /usr/lib/scala
RUN ln -s /usr/lib/scala/bin/scala /usr/local/bin/scala 

RUN useradd -ms /bin/bash ec2-user
RUN chown -R ec2-user:ec2-user /home/ec2-user
RUN echo ec2-user:vagrant | chpasswd
RUN echo root:vagrant | chpasswd

ADD https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub /home/ec2-user/.ssh/authorized_keys
RUN chown -R ec2-user:ec2-user /home/ec2-user/.ssh
RUN chmod 0600 /home/ec2-user/.ssh/authorized_keys
RUN chmod 0700 /home/ec2-user/.ssh
RUN echo "ec2-user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir /var/run/sshd

RUN yum install -y --quiet bzip2 && \
    mkdir -p /downloads && \
    mkdir -p /opt && \
    cd /downloads && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    echo "Downloading Miniconda..." && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh && \
    /bin/bash /downloads/Miniconda-latest-Linux-x86_64.sh -b -p /opt/conda && \
    /opt/conda/bin/conda install --yes scikit-learn==0.16.1 && \
    rm -rf /downloads

ENV LANG C.UTF-8

USER ec2-user
ENV HOME /home/ec2-user
WORKDIR /home/ec2-user
EXPOSE 22

CMD ["sudo", "/usr/sbin/sshd", "-D"]