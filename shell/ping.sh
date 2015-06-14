#/bin/bash
#测试局域网内有多少机器存活

for n in {120..130}
do
	host=172.16.158.$n
	ping -c 2 $host &>/dev/null
	if [ $? = 0 ]; then
		echo "$host is UP"
		echo "$host" >> /root/alive.txt
	else
		echo "$host is DOWN"
	fi
done
