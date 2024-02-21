#! /bin/bash

# load variables
host1_pvt_ip=$1
printf "Loaded Host 1 IP : ${host1_pvt_ip}"
host2_pvt_ip=$2
printf "Loaded Host 2 IP : ${host2_pvt_ip}"
userName=$(whoami)
printf "Current User : ${userName}"
logFilePath=/home/${userName}/ansibleServer_$(date +%y%m%d%H%M%S).log
printf "Running Ansible-Server Installation Script....."
printf "Use 'tail -f ${logFilePath}' in another terminal/session to see the log-tail of this script."

sudo su
echo "Logging in as super user...." >> ${logFilePath}
echo "Installing wget...." >> ${logFilePath}
yum install wget -y
clear
echo "Downloading epel-7....." >> ${logFilePath}
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
echo "Downloaded epel-7....." >> ${logFilePath}
echo "Installing epel-7....." >> ${logFilePath}
yum install epel-release-latest-7.noarch.rpm -y
echo "Installed epel-7....." >> ${logFilePath}
echo "Updating System...." >> ${logFilePath}
yum update -y
echo "System Update Complete." >> ${logFilePath}
printf "Installing Software Packages:\n Git \n Python\n Python-Devel\n Python-PIP\n Open-SSL\n Ansible\n" >> ${logFilePath}
yum install git python python-devel python-pip openssl ansible -y
printf "All Pacakges Installed." >> ${logFilePath}

echo "Ansible: Enabling Ansible Inventory..." >> ${logFilePath}
sed -i 's@#inventory      = /etc/ansible/hosts@inventory      = /etc/ansible/hosts@g' /etc/ansible/ansible.cfg
echo "Ansible: Enabling root/sudo user..." >> ${logFilePath}
sed -i 's@#sudo_user      = root@sudo_user      = root@g' /etc/ansible/ansible.cfg
echo "Ansible: Adding New Host [devops1] : ${host1_pvt_ip}" >> ${logFilePath}
echo "[devops1]" >> /etc/ansible/hosts
echo "172.31.39.114" >> /etc/ansible/hosts
echo "Ansible: Adding New Host [devops2] : ${host2_pvt_ip}" >> ${logFilePath}
echo "[devops2]" >> /etc/ansible/hosts
echo "172.31.47.182" >> /etc/ansible/hosts
printf "Ansible: Adding New Host-Group [devops] : \n${host1_pvt_ip}\n${host2_pvt_ip}" >> ${logFilePath}
echo "[devops]" >> /etc/ansible/hosts
echo "172.31.39.114" >> /etc/ansible/hosts
echo "172.31.47.182" >> /etc/ansible/hosts
echo "Ansible: Adding Local-Host [local] to Inventory..." >> ${logFilePath}
echo "[local]" >> /etc/ansible/hosts
echo "localhost" >> /etc/ansible/hosts
echo "Ansible: Inventory Loaded." >> ${logFilePath}
echo "Creating New User: ansible" >> ${logFilePath}
adduser ansible
echo "anisble1234" | passwd --stdin ansible
echo "Adding User:ansible to SUDOERS...." >> ${logFilePath}
echo "ansible ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Updating SSH configurations......" >> ${logFilePath}
sed -i 's@#PermitRootLogin yes@PermitRootLogin yes@g' /etc/ssh/sshd_config
sed -i 's@#PasswordAuthentication yes@PasswordAuthentication yes@g' /etc/ssh/sshd_config
sed -i 's@PasswordAuthentication no@#PasswordAuthentication no@g' /etc/ssh/sshd_config
echo "Restarting SSH Service....." >> ${logFilePath}
service sshd restart
echo "Creating Key-Pairs for SSH Login...." >> ${logFilePath}
su - ansible
yum update -y
ssh-keygen -f /home/ansible/.ssh/id_rsa -N ''
echo "Loading Key-Pairs to Target Servers....." >> ${logFilePath}
cd .ssh
echo "yes" | ssh-copy-id ansible@172.31.39.114
sshpass -p "anisble1234" ssh-copy-id ansible@172.31.39.114
echo "yes" | ssh-copy-id ansible@172.31.47.182
sshpass -p "anisble1234" ssh-copy-id ansible@172.31.47.182
echo "Loading Key-Pairs to Target Servers : COMPLETED" >> ${logFilePath}
echo "Ansible-Server : Setup Completed" >> ${logFilePath}


