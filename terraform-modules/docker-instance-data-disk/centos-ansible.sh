#!/bin/bash

# Only run this script once
if [ -f /etc/sysconfig/gce-metadata-run ];
    then
    exit 0
fi

#stop and disable firewalld
systemctl stop firewalld.service
systemctl disable firewalld.service

#install pip and ansible
yum install epel-release -y
yum update
yum install python36 python36-pip git jq python-setuptools -y
python3.6 -m pip install --upgrade pip
python3.6 -m pip install virtualenv
virtualenv /usr/local/bin/ansible
source /usr/local/bin/ansible/bin/activate
python3.6 -m pip install ansible==2.7.8
python3.6 -m pip install hvac 
python3.6 -m pip install ansible_merge_vars

# convert labels to env vars
gcloud compute instances list --filter="name:$(hostname)" --format 'value(labels)' | tr ';' '\n' | while read var ; do key="${var%=*}"; value="${var##*=}" ; key=$(echo $key | tr '[a-z]' '[A-Z]') ; echo "export $key=\"$value\"" ; done  > /etc/bashrc-labels

# gcloud compute instances list --filter="name:$(hostname)" --format=json | jq .[].labels | tr -d '"|,|{|}|:' | while read key value ; do if [ ! -z "${key}" ] ; then  key=$(echo $key | tr '[a-z]' '[A-Z]') ; echo "export $key=\"$value\"" ; fi ; done > /etc/bashrc-labels

echo "test -f /etc/bashrc-labels && source /etc/bashrc-labels" >> /etc/bashrc
source /etc/bashrc-labels

#env vars and paths
echo "source /usr/local/bin/ansible/bin/activate " >> /root/.bashrc
echo "export PATH=/usr/local/bin:$PATH" >> /root/.bashrc
# echo "export GPROJECT=${gproject_ansible}"  >> /root/.bashrc
# echo "export ANSIBLE_BRANCH=${ansible_branch}"  >> /root/.bashrc
source /root/.bashrc

#needed for checkout otherwise ssh cannot git clone or checkout
mkdir ~/.ssh
ssh-keyscan -H github.com >> ~/.ssh/known_hosts

# Fetch all the common setup scripts from GCE metadata
#curl -sH 'Metadata-Flavor: Google' http://metadata/computeMetadata/v1/project/attributes/ansible-key > /root/.ssh/id_rsa
#chmod 0600 /root/.ssh/id_rsa

#find newly added disks without rebooting ie:scratch disks
/usr/bin/rescan-scsi-bus.sh

#one time anisble run
ansible-pull provisioner.yml -C ${ANSIBLE_BRANCH} -d /var/lib/ansible/local -U https://github.com/broadinstitute/dsp-ansible-configs.git -i hosts >> /root/ansible-provisioner-firstrun.log 2>&1

# sh /root/ansible-setup.sh 2>&1 | tee /root/ansible-setup.log

touch /etc/sysconfig/gce-metadata-run
chmod 0644 /etc/sysconfig/gce-metadata-run

# Prevent yum-cron from arbitrarily updating docker packages
echo "exclude = docker* containerd.io" >> /etc/yum/yum-cron.conf
