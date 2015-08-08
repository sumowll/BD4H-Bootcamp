#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Install puppet agent
yum -y --nogpg install http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
yum -y install curl  || yum -y install curl 
yum -y install sudo || yum -y install sudo
yum -y install unzip || yum -y install unzip
yum -y install tar  || yum -y install tar 

rpm --rebuilddb
yum -y --nogpg install puppet || yum -y --nogpg install puppet

# Setup rng-tools to improve virtual machine entropy performance.
# The poor entropy performance will cause kerberos provisioning failed.
yum -y install rng-tools
sed -i.bak 's/EXTRAOPTIONS=\"\"/EXTRAOPTIONS=\"-r \/dev\/urandom\"/' /etc/sysconfig/rngd
service rngd start

# Install puppet modules
puppet apply /bootcamp-vm/puppet-modules.pp

mkdir -p /data/{1,2}

sysctl kernel.hostname=`hostname -f`

# Unmount device /etc/hosts and replace it by a shared hosts file
echo -e "`hostname -i`\t`hostname -f`" >> /bootcamp-vm/hosts
umount /etc/hosts
mv /etc/hosts /etc/hosts.bak
ln -s /bootcamp-vm/hosts /etc/hosts

# Prepare puppet configuration file
mkdir -p /etc/puppet/hieradata
cp /bootcamp-vm/puppet/hiera.yaml /etc/puppet
cp -r /bootcamp-vm/puppet/hieradata/bigtop/ /etc/puppet/hieradata/
cat > /etc/puppet/hieradata/site.yaml << EOF
bigtop::hadoop_head_node: $1
hadoop::hadoop_storage_dirs: [/data/1, /data/2]
bigtop::bigtop_repo_uri: $2
hadoop_cluster_node::cluster_components: $3
bigtop::jdk_package_name: $4
EOF
