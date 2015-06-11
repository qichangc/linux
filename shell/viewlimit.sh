#!/bin/bash
#查看某个程序可以打开文件的最大数，参数是该程序的pid
cat /proc/$1/limits | grep "Max open files"

