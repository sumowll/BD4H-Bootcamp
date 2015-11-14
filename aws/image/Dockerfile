FROM bigtop/deploy:centos-6
MAINTAINER Hang Su "hangsu@gatech.edu"

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

USER ec2-user
ENV HOME /home/ec2-user
WORKDIR /home/ec2-user
EXPOSE 22

CMD ["sudo", "/usr/sbin/sshd", "-D"]