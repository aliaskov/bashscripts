#!/usr/bin/bash
# 0,15,30,45 * * * * /opt/mysql/backup_binlogs.sh > /var/backup/mysql/logs/binlog_$(date +\%d-\%m-\%Y_\%H\%M).log 2>&1





BINLOGS=`ls -rt  /var/lib/mysql/s42ldb03-bin.??????`
ACTIVE=`ls -rt  /var/lib/mysql/s42ldb03-bin.??????|tail -1`
BINLOGDIR=/var/backup/mysql/binlogs
LOGDIR=/var/backup/mysql/logs
LOCK=/tmp/binlog.lck
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
 if [ -f $LOCK ]; then
   rm $LOCK
   echo "REMOVING LOCKFILE"
 else
  echo "LOCK NOT FOUND"
  exit 1
 fi
}

function copy_logs {
 FLUSH=`/bin/mysqladmin -uroot -pPASSWORD flush-logs`
 for l in $BINLOGS
  do
   if [ "${l}" != "$ACTIVE" ] && [ "$ACTIVE" != "" ]; then
    BASENAME=`basename $l`
    echo "COPYING: " $BASENAME
    /bin/rsync -a $l $BINLOGDIR/$BASENAME
   fi
  done
}

function cleanup {
 /bin/find $LOGDIR -mtime +$LOGDELTA -name binlog\*.log -exec rm -f {} \;
 /bin/find $BINLOGDIR -mtime +$DELTA -exec rm -f {} \;
}

### MAIN ###

echo "START" `date +%d%m%Y_%H%M`
set_lock
copy_logs
cleanup
rm_lock
echo "STOP" `date +%d%m%Y_%H%M`

exit 0
