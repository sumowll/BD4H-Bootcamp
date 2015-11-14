# -*- mode: ruby -*-
# vi: set ft=ruby :

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

require 'fileutils'

# number of instances
$num_instances = 1
$vagrantyamlconf = "vagrantconfig.yaml"

require "yaml"

_config = YAML.load(File.open(File.join(File.dirname(__FILE__), $vagrantyamlconf), File::RDONLY).read)
CONF = _config

ENV['VAGRANT_DEFAULT_PROVIDER'] ||= 'docker'

Vagrant.require_version ">= 1.6.0"

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # nodes definition
  (1..$num_instances).each do |i|
    config.vm.define "bootcamp#{i}" do |bigtop|
      # docker container settings
      bigtop.vm.provider "docker" do |d|
        #d.image = "bigtop"
        d.build_dir = "."
        d.create_args = ["--privileged=true", "-m", CONF["docker"]['memory_size'] + "m"]
        d.has_ssh = false # We have decided to pipe commands to docker instead of ssh, due to ssh hang issue in vagrant.
      end
      bigtop.ssh.username = "{{ item }}"
      bigtop.ssh.insert_key = "true"
      bigtop.ssh.port = 22
      bigtop.vm.hostname = "bootcamp#{i}.docker"
      bigtop.vm.synced_folder "..", "/home/{{ item }}"
    end
  end
end