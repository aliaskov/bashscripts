#!/usr/bin/env bash

logdir1=/opt/log
logdir2=/var/logs/tomcat
logdir3=/var/log/apache2


# find all files older than x days
# find $logdir1 $logdir2 $logdir3 -maxdepth 1 -type f -name "*log*" -mmin +1440 ! -name "*gz*" -exec ls -lath {} \;
# find all files older than x days and gzip.
# the backuped file is removed by gzip
find $logdir1 $logdir2 -maxdepth 1 -type f -name "*.log" -mmin +1440 -print -exec gzip -q {} \;
find $logdir1 $logdir2 -maxdepth 1 -type f -name "*.txt" -mmin +1440 -print -exec gzip -q {} \;
find $logdir1 $logdir2 $logdir3 -maxdepth 1 -type f -name "*log*" -mmin +1440 ! -name "*gz*" -print -exec gzip -q {} \;
find $logdir1 $logdir2 -maxdepth 2 -type f -name "*default*" -mmin +1440 ! -name "*gz*" -print -exec gzip -q {} \;

###delete .gz files older than x days
find $logdir1 $logdir2 $logdir3 -maxdepth 1 -type f \( -name '*.gz' \)  -mtime +7 -delete
