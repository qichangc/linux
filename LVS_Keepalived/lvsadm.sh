#!/bin/bash

VIP=172.16.158.140

#设定虚拟IP地址

. /etc/rc.d/init.d/functions

#调用函数库

case "$1" in

start)

       ifconfig lo:0 $VIP netmask 255.255.255.255 broadcast $VIP

                   ##建立eth0:1网卡设定为虚拟IP地址

       /sbin/route add -host $VIP dev lo:0

       echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore

       echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce

       echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore

       echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce

       sysctl -p >/dev/null 2>&1

       echo "RealServer Start OK"

                   #还没看，应该是和路由表有问题

 

       ;;

stop)

       ifconfig lo:0 down

       route del $VIP >/dev/null 2>&1

                   #清除路由表中的虚拟IP路由信息

       echo "0" >/proc/sys/net/ipv4/conf/lo/arp_ignore

       echo "0" >/proc/sys/net/ipv4/conf/lo/arp_announce

       echo "0" >/proc/sys/net/ipv4/conf/all/arp_ignore

       echo "0" >/proc/sys/net/ipv4/conf/all/arp_announce

       echo "RealServer Stoped"

       ;;

status)

        # Status of LVS-DR real server.

        islothere=`/sbin/ifconfig lo:0 | grep $VIP`

        isrothere=`netstat -rn | grep "lo:0" | grep $VIP`

        if [ ! "$islothere" -o ! "isrothere" ];then

            # Either the route or the lo:0 device

            # not found.

            echo "LVS-DR real server Stopped."

        else

            echo "LVS-DR Running."

        fi

;;

*)

        # Invalid entry.

        echo "$0: Usage: $0 {start|status|stop}"

        exit 1

;;

esac

