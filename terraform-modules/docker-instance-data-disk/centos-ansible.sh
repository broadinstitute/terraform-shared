#!/bin/bash

# Only run this script once
if [ -f /etc/sysconfig/gce-metadata-run ];
    then
    exit 0
fi

# exit on error
set -e

#stop and disable firewalld
systemctl disable --now firewalld

# update path so pip/virtualenv are available
echo "export PATH=/usr/local/bin:${PATH}" >> /root/.bashrc
source /root/.bashrc

#install pip and ansible
yum install epel-release -y
yum update
yum install python3.12 python3.12-pip git jq python-setuptools -y
python3.12 -m pip install --upgrade pip virtualenv -y
virtualenv /usr/local/bin/ansible
source /usr/local/bin/ansible/bin/activate
python3.12 -m pip install hvac ansible_merge_vars ansible==2.7.8 -y

# convert labels to env vars
gcloud compute instances list --filter="name:$(hostname)" --format 'value(labels)' | tr ';' '\n' | while read var ; do key="${var%=*}"; value="${var##*=}" ; key=$(echo $key | tr '[a-z]' '[A-Z]') ; echo "export $key=\"$value\"" ; done  > /etc/bashrc-labels

echo "test -f /etc/bashrc-labels && source /etc/bashrc-labels" >> /etc/bashrc
source /etc/bashrc-labels

#env vars and paths
echo "source /usr/local/bin/ansible/bin/activate " >> /root/.bashrc
source /root/.bashrc

#needed for checkout otherwise ssh cannot git clone or checkout
mkdir -p ~/.ssh
ssh-keyscan -H github.com >> ~/.ssh/known_hosts

#find newly added disks without rebooting ie:scratch disks
/usr/bin/rescan-scsi-bus.sh

#one time anisble run
ansible-pull provisioner.yml -C ${ANSIBLE_BRANCH} -d /var/lib/ansible/local -U https://github.com/broadinstitute/dsp-ansible-configs.git -i hosts >> /root/ansible-provisioner-firstrun.log 2>&1

# manually install Docker since ansible will only run on python3.6
dnf -y install dnf-plugins-core
dnf update
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf -y install docker-ce docker-ce-cli containerd.io
systemctl enable --now docker

touch /etc/sysconfig/gce-metadata-run
chmod 0644 /etc/sysconfig/gce-metadata-run

# add users to Docker group
useradd jenkins
usermod -aG docker root
usermod -aG docker ubuntu
usermod -aG docker jenkins

# Prevent dnf from arbitrarily updating docker packages
echo "exclude=docker*,containerd.io" >> /etc/dnf/dnf.conf
