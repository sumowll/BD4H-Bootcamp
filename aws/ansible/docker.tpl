FROM sunlab/bigdata:0.01
MAINTAINER Hang Su "hangsu@gatech.edu"

USER root
RUN useradd -ms /bin/bash {{ item.1 }} -u {{ item.0 + 520 }}
RUN chown -R {{ item.1 }}:{{ item.1 }} /home/{{ item.1 }}
RUN echo {{ item.1 }}:vagrant | chpasswd
RUN echo root:vagrant | chpasswd

ADD https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub /home/{{ item.1 }}/.ssh/authorized_keys
RUN chown -R {{ item.1 }}:{{ item.1 }} /home/{{ item.1 }}/.ssh
RUN chmod 0600 /home/{{ item.1 }}/.ssh/authorized_keys
RUN chmod 0700 /home/{{ item.1 }}/.ssh
RUN echo "{{ item.1 }} ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

USER {{ item.1 }}
ENV HOME /home/{{ item.1 }}
WORKDIR /home/{{ item.1 }}
EXPOSE 22

CMD ["sudo", "/usr/sbin/sshd", "-D"]