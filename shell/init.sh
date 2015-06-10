#!/bin/bash

#add the epel repo
#下载的文件都放在这里
cd /usr/local/src 
#最小化安装的系统可能没有wget，需要先安装wget，然而，没有配置yum怎么安装wget，死循环吗？
#NO NO NO 可以先把wget的rpm包用puppet推送过去执行下呀，或者在安装系统的时候就设置好要安装的一些软件
wget http://mirrors.ustc.edu.cn/fedora/epel//5/x86_64/epel-release-5-4.noarch.rpm
rpm -ivh epel-release-5-4.noarch.rpm
#add the rpmforge repo
cd /usr/local/src
wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm
rpm -ivh rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm
#yum install sysstat
#安装一些基础的库，以便安装软件
yum -y install gcc gcc-c++ vim-enhanced unzip unrar sysstat
#set the ntp
#安装ntp，同步时间
yum -y install ntp
#如果是局域网内，不能访问外网，就同步局域网内的ntp服务器
echo "01 01 ***/usr/sbin/ntpdate ntp.api.bz >> /dev/null 2>&1" >> /etc/crontab
ntpdate ntp.api.bz
service crond restart
#set the file limit
#修改文件句柄的上限，不然生产服务器在并发量大的情况下，会报错。
ulimit -SHn 65535
echo "ulimit -SHn 65535" >> /etc/rc.local
cat >> /etc/security/limits.conf << EOF
*      soft  nofile    60000
*      hard  nofile    65535
EOF
#tune kernel parametres
#调整内核参数
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 1024 65535
EOF
#立即生效
/sbin/sysctl -p

#disable selinux
sed -i 's@SELINUX=enforcing@SELINUX=disabled@' /etc/selinux/config
#ssh setting
sed -i -e '74 s/^/#/' -i -e '76 s/^/#/' /etc/ssh/sshd_config
sed -i 's@#UseDNS yes@UseDNS no@' /etc/ssh/sshd_config
service sshd restart
#disable ipv6
echo "alias net-pf-10 off" >> /etc/modprobe.conf
echo "alias ipv6 off" >> /etc/modprobe.conf
echo "install ipv6 /bin/true" >> /etc/modprobe.conf
echo "IPV6INIT=no" >> /etc/sysconfig/network
sed -i 's@NETWORKING_IPV6=yes@NETWORKING_IPV6=no@' /etc/sysconfig/network
chkconfig ip6tables off
#vim setting
echo "syntax on" >> /root/.vimrc
echo "set nohlsearch" >> /root/.vimrc
#chkconfig off services
chkconfig bluetooth off
chkconfig sendmail off
chkconfig kudzu off
chkconfig nfslock off
chkconfig portmap off
chkconfig iptables off
chkconfig autofs off
chkconfig yum-updatesd off
#reboot system
Reboot

