#!/usr/bin/bash
#30 1 * * * /opt/mysql/dumpall.sh > /var/backup/mysql/logs/dumpall_$(date +\%d-\%m-\%Y).log 2>&1
#Hallo, Sergei Bugaenko was here

DBLIST=`echo "show databases;"|/usr/bin/mysql -s -uroot -pPASSWORD`
LOCK=/tmp/mysql_dump.lck
DATETIME=`date +%d%m%Y`
DUMPDIR="/var/backup/mysql/dumps"
LOGDIR="/var/backup/mysql/logs"
YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`
DELTA=7
LOGDELTA=7



function set_lock {
 if [ ! -f $LOCK ]; then
   touch $LOCK
   echo "SETTING LOCKFILE"
 else
   echo "LOCKFILE EXITS"
   exit 1
 fi
}

function rm_lock {
 ##echo "FISTATE: $FISTATE"
 if [ -f $LOCK ] && [ "$FISTATE" = "Yes Yes" ]; then
   rm $LOCK
   echo "REMOVING LOCKFILE"
 else
  echo "SLAVE NOT RUNNING OR LOCKFILE DOES NOT EXIST"
 fi
}

function slave {
 case "$1" in
  stop)
   echo "stop slave"|/usr/bin/mysql -uroot -pPASSWORD
   echo "STOPPING SLAVE"
   ;;
  start)
   echo "start slave"|/usr/bin/mysql -uroot -pPASSWORD
   echo "STARTING SLAVE"
   echo "SETTING GRACE PERIOD TO 60 SECONDS"
   sleep 60
   ;;
 esac
}

function backup {
 if [ "$DBLIST" != "" ] && [ "$FISTATE" = "No No" ]; then
  for d in $DBLIST
   do
    if ([ "$d" == "information_schema" ] || [ "$d" == "performance_schema" ] || [ "$d" == "mysql" ] ); then
     echo "SKIPPING $d"
    else
     echo "DUMPING $d"
     /usr/bin/mysqldump -uroot -pPASSWORD  --single-transaction --events $d >$DUMPDIR/${d}_$DATETIME.dmp
    fi
   done
 else
  echo "SLAVE STILL RUNNING OR DB LIST IS EMPTY"
  exit 1
 fi
}

function cleanup {
 ## /usr/bin/find $DUMPDIR -mtime +2 -name \*.dmp -exec rm -f {} \;
 ## /usr/bin/find $LOGDIR -mtime +5 -name \*.log -exec rm -f {} \;
 /usr/bin/find $DUMPDIR -mtime +$DELTA -name \*.dmp -exec rm -f {} \;
 /usr/bin/find $LOGDIR -mtime +$LOGDELTA -name \*.log -exec rm -f {} \;
}

function check_state {
 STATE=`echo "show slave status \G;"|mysql -s -uroot -pPASSWORD|grep -E "Slave_IO_Running|Slave_SQL_Running"`
 FISTATE=`echo $STATE|cut -d " " -f2,4`
 ## echo $FISTATE
}

function purgelogs {
 let DAY=$DAY-$DELTA
 PURGE="PURGE BINARY LOGS BEFORE '$YEAR-$MONTH-$DAY 23:59:59';"
 echo $PURGE|/usr/bin/mysql -uroot -pPASSWORD
 echo "PURGING LOGS BEFORE $YEAR-$MONTH-$DAY 23:59:59"
}

## MAIN ##

echo "START" `date +%d%m%Y_%H%M`
set_lock
slave stop
check_state
backup
slave start
purgelogs
check_state
rm_lock
cleanup
echo "STOP" `date +%d%m%Y_%H%M`

exit 0
