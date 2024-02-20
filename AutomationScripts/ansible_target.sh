#! /bin/bash
sudo su
adduser ansible
echo "anisble1234" | passwd --stdin ansible
echo "ansible ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sed -i 's@#PermitRootLogin yes@PermitRootLogin yes@g' /etc/ssh/sshd_config
sed -i 's@#PasswordAuthentication yes@PasswordAuthentication yes@g' /etc/ssh/sshd_config
sed -i 's@PasswordAuthentication no@#PasswordAuthentication no@g' /etc/ssh/sshd_config
service sshd restart
