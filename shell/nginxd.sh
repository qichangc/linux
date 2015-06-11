#!/bin/bash
#nginx 配置脚本 非官方版本

#source function library
./etc/rc.d/init.d/functions

#source networking configure
./etc/sysconfig/network

#check that networking is up
[ ${NETWORKING} = "no" ] && exit 0
RETVAL=0
prog="nginx"

nginxDir=/usr/local/nginx
nginxd=$nginxDir/sbin/nginx
nginxConf=$nginxDir/conf/nginx.conf
nginxPid=$nginxDir/nginx.pid

nginx_check()
{
	if [ [ -e $nginxPid ] ];then
		ps aux | grep -v grep | grep -q nginx
		if(($?==0));then
			echo "$prog already running..."
			exit 1
		else
			rm -rf $nginxPid &>/dev/null
		fi
	fi
}

start()
{
	nginx_check
	if(($?!=0));then
		true
	else
		echo -n $"Starting $prog:"
		daemon $nginxd -c $nginxConf
		RETVAL=$?
		echo
		[ $RETVAL = 0 ] && touch /var/lock/subsys/nginx
		return $RETVAL
	fi
}

stop()
{
	echo -n $"Stopping $prog:"
	killproc $nginxd
	RETVAL=$?
	echo
	[ $RETVAL = 0 ] && rm -rf /var/lock/subsys/nginx $nginxPid
}

reload()
{
	echo -n $"Reloading $prog:"
	killproc $nginxd -HUP
	RETVAL=$?
	echo
}

monitor()
{
	status $prog &>/dev/null
	if(($?==0)); then
		RETVAL=0
	else
		RETVAL=7
	fi
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		start
		;;
	reload)
		reload
		;;
	status)
		status $prog
		RETVAL=$?
		;;
	monitor)
		monitor
		;;
	*)
		echo $"Usage: $0 {start|stop|restart|reload|status|monitor}"
		RETVAL=1
esac

exit $RETVAL
	
