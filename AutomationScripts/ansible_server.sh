#! /bin/bash
sudo su
yum install wget -y
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install epel-release-latest-7.noarch.rpm -y
yum update -y
yum install git python python-devel python-pip openssl ansible -y
sed -i 's@#inventory      = /etc/ansible/hosts@inventory      = /etc/ansible/hosts@g' /etc/ansible/ansible.cfg
sed -i 's@#sudo_user      = root@sudo_user      = root@g' /etc/ansible/ansible.cfg
echo "[devops1]" >> /etc/ansible/hosts
echo "172.31.34.79" >> /etc/ansible/hosts
#echo "[devops2]" >> /etc/ansible/hosts
#echo "172.31.15.96" >> /etc/ansible/hosts
#echo "[devops]" >> /etc/ansible/hosts
#echo "172.31.34.79" >> /etc/ansible/hosts
#echo "172.31.15.96" >> /etc/ansible/hosts
echo "[local]" >> /etc/ansible/hosts
echo "localhost" >> /etc/ansible/hosts
adduser ansible
echo "anisble1234" | passwd --stdin ansible
echo "ansible ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sed -i 's@#PermitRootLogin yes@PermitRootLogin yes@g' /etc/ssh/sshd_config
sed -i 's@#PasswordAuthentication yes@PasswordAuthentication yes@g' /etc/ssh/sshd_config
sed -i 's@PasswordAuthentication no@#PasswordAuthentication no@g' /etc/ssh/sshd_config
service sshd restart
su - ansible
yum update -y
ssh-keygen -f /home/ansible/.ssh/id_rsa -N ''
cd .ssh
echo "anisble1234" | ssh-copy-id --stdin ansible@172.31.34.79

