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

usage() {
    echo "usage: $PROG [-C file ] args"
    echo "       -C file                                   Use alternate file for vagrantconfig.yaml"
    echo "  commands:"
    echo "       -c NUM_INSTANCES, --create=NUM_INSTANCES  Create a Docker based Bigtop Hadoop cluster"
    echo "       -p, --provision                           Deploy configuration changes"
    echo "       -s, --smoke-tests                         Run Bigtop smoke tests"
    echo "       -d, --destroy                             Destroy the cluster"
    echo "       -h, --help"
    exit 1
}

create() {
    vagrant up --no-parallel
    if [ $? -ne 0 ]; then
        echo "Docker container(s) startup failed!";
    exit 1;
    fi
    nodes=(`vagrant status |grep bootcamp |awk '{print $1}'`)
    hadoop_head_node=(`echo "hostname -f" |vagrant ssh ${nodes[0]} |tail -n 1`)
    repo=$(get-yaml-config repo)
    components="[`echo $(get-yaml-config components) | sed 's/ /, /g'`]"
    jdk=$(get-yaml-config jdk)

    # setup environment before running bigtop puppet deployment
    for node in ${nodes[*]}; do
        (
            echo "preparing on $node"
            echo "sudo /bigtop-home/bigtop-deploy/vm/utils/setup-env-centos.sh" |vagrant ssh $node
            echo "sudo /bigtop-home/bigtop-deploy/vm/vagrant-puppet-docker/provision.sh $hadoop_head_node $repo \"$components\" $jdk" |vagrant ssh $node
        ) &
    done
    wait

    # run bigtop puppet (master node need to be provisioned before slave nodes)
    bigtop-puppet ${nodes[0]}
    for ((i=1 ; i<${#nodes[*]} ; i++)); do
        bigtop-puppet ${nodes[$i]} &
    done
    wait
}

provision() {
    nodes=(`vagrant status |grep bigtop |awk '{print $1}'`)
    for node in ${nodes[*]}; do
        bigtop-puppet $node &
    done
    wait
}

destroy() {
    vagrant destroy -f
    rm -rvf ./hosts ./config.rb
}

bigtop-puppet() {
    echo "sudo puppet apply -d --confdir=/etc/puppet --modulepath=/bigtop-home/bigtop-deploy/puppet/modules:/etc/puppet/modules /bigtop-home/bigtop-deploy/puppet/manifests/site.pp" |vagrant ssh $1
    post-fix $1
}

post-fix () {
    echo 'sudo -u hdfs bash -c "hdfs dfs -mkdir /user/ec2-user && hdfs dfs -chown ec2-user /user/ec2-user"' |vagrant ssh $1
    echo 'sudo usermod -a -G hadoop,yarn ec2-user' |vagrant ssh $1
    echo 'sudo chmod -R g+w /data && sudo chgrp -R hadoop /data' |vagrant ssh $1
    echo 'sudo /sbin/service hadoop-hdfs-namenode stop' |vagrant ssh $1
    echo 'sudo /sbin/service hadoop-hdfs-datanode stop' |vagrant ssh $1
    echo 'sudo /sbin/service hadoop-yarn-resourcemanager stop' |vagrant ssh $1
    echo 'sudo /sbin/service hadoop-yarn-nodemanager stop' |vagrant ssh $1
    echo 'sudo /sbin/service hadoop-mapreduce-historyserver stop' |vagrant ssh $1
    echo 'sudo /sbin/service spark-worker stop' |vagrant ssh $1
    echo 'sudo /sbin/service spark-master stop' |vagrant ssh $1
    echo 'sudo /sbin/service hadoop-yarn-proxyserver' |vagrant ssh $1
}

get-yaml-config() {
    RUBY_EXE=ruby
    which ruby > /dev/null 2>&1
    if [ $? -ne 0 ]; then
    # use vagrant embedded ruby on Windows
        RUBY_EXE=$(dirname $(which vagrant))/../embedded/bin/ruby
    fi
    RUBY_SCRIPT="data = YAML::load(STDIN.read); puts data['$1'];"
    cat ${vagrantyamlconf} | $RUBY_EXE -ryaml -e "$RUBY_SCRIPT" | tr -d '\r'
}

PROG=`basename $0`

if [ $# -eq 0 ]; then
    usage
fi

vagrantyamlconf="vagrantconfig.yaml"
while [ $# -gt 0 ]; do
    case "$1" in
    -c|--create)
        create
        shift;;
    -C|--conf)
        if [ $# -lt 2 ]; then
          echo "Alternative config file for vagrantconfig.yaml" 1>&2
          usage
        fi
    vagrantyamlconf=$2
        shift 2;;
    -p|--provision)
        provision
        shift;;
    -d|--destroy)
        destroy
        shift;;
    -h|--help)
        usage
        shift;;
    *)
        echo "Unknown argument: '$1'" 1>&2
        usage;;
    esac
done