#Install wget
dnf -y install wget
#webmin repo
cat >/etc/yum.repos.d/webmin.repo <<EOL
[Webmin]
name=Webmin Distribution Neutral
#baseurl=http://download.webmin.com/download/yum
mirrorlist=http://download.webmin.com/download/yum/mirrorlist
enabled=1
EOL
#webmin key
wget http://www.webmin.com/jcameron-key.asc && rpm --import jcameron-key.asc
#installing software
dnf -y install epel-release && yum repolist && dnf -y install htop tmux xrdp ; dnf -y install webmin docker podman-compose
#add firewall rules
firewall-cmd --zone=public --permanent --add-port=10000/tcp
firewall-cmd --zone=public --permanent --add-port=3389/tcp
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --zone=public --permanent --add-service=cockpit
firewall-cmd --reload
# starting services
systemctl start cockpit && systemctl enable cockpit.socket
systemctl start xrdp.service && systemctl enable xrdp.service
#Set kernal limit to 3
sed -i 's/installonly_limit=5/installonly_limit=3/g' /etc/yum.conf
echo Finished
