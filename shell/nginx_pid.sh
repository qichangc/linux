#/bin/bash
#在nginx+keepalived架构下，监测nginx进程是否存在，不存在就关闭本机keepalived

while :
do
	nginxpid=`ps -C nginx --no-header | wc -l`
	if [ $nginxpid -eq 0 ];then
		ulimit -SHn 65535
		/usr/local/nginx/sbin/nginx
		sleep 5
	        nginxpid=`ps -C nginx --no-header | wc -l`
		if [ $nginxpid -eq 0 ];then
			/etc/init.d/keepalived stop
		fi
	fi
	sleep 5
done

