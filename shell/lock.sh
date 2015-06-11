#!/bin/bash
# 主要是配合计划任务，比如某些任务执行的时间长的话，防止脚本没有执行完毕就再执行

LOCKFILE=./$(basename $0)_lockfile 
echo $$
 
if [ -f $LOCKFILE ];then 
	MYPID=$(cat $LOCKFILE)
	echo $MYPID 
	ps -p $MYPID | grep  $MYPID &>/dev/null  #如果程序异常退出，锁文件存在，而锁文件里的pid已经不在进程了 
	[ $? -eq 0 ] && echo "The script backup.sh is running" && exit 1 
else
	 
	echo $$ > $LOCKFILE 
fi 
echo "The script is running!" 
read 
echo "The script is stop!" 
rm -rf $LOCKFILE 

