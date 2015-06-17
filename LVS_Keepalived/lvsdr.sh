#/bin/bash
VIP=172.16.158.140
RIP1=172.16.158.128
RIP2=172.16.158.135

. /etc/rc.d/init.d/functions
case "$1" in

start)

        echo "stat LVS of DirectorServer"

        /sbin/ipvsadm --set 900 120 300

                   #保持回话

        /sbin/ifconfig eth0:1 $VIP broadcast $VIP netmask 255.255.255.0 up

                   #建立eth0:1网卡设定为虚拟IP地址

        /sbin/route add -host $VIP dev eth0:1

        /sbin/ipvsadm -C

#清除内核虚拟服务器表中的所有记录

        /sbin/ipvsadm -A -t $VIP:80 -s wrr

                   #增加一台新的提供TCP服务的虚拟服务器列表

        /sbin/ipvsadm -a -t $VIP:80 -r $RIP1:80 -g

                   #增加一台提供TCP服务的真实虚拟主机

        /sbin/ipvsadm -a -t $VIP:80 -r $RIP2:80 -g

                   #同上

        /sbin/ipvsadm

;;

stop)

        echo "Close LVS Directorserver"

        /sbin/ifconfig eth0:1 down

                   #关闭虚拟IP

        /sbin/ipvsadm -C

                   #清除虚拟服务器列表

;;

*)

        echo "usage:$0 {start|stop}"

 

exit 1

esac
