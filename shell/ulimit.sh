#!/bin/bash
#查看nginx可以打开的最大文件数
# 功能待测试
for pid in 'ps aux |grep nginx |grep -v grep|awk '{print$2}''
do
cat /proc/${pid}/limits |grep 'Max open files'
done


