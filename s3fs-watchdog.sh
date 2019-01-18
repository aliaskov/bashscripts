#!/bin/bash
#
# s3fs-watchdog.sh
#
# Run from the root user's crontab to keep an eye on s3fs which should always
# be mounted. 
#
FILE=/var/www/test.txt
BUCKET=S3BucketName
MOUNTPATH=/var/www
MOUNT=/bin/mount
UMOUNT=/bin/umount
NOTIFY=user@domain.com
DATE=/bin/date
RUNUSER=/sbin/runuser
AWS_CLI=/home/ec2-user/.local/bin/aws


if [ -f $FILE ]; then
   echo "File $FILE exists. s3fs is running in this case so we do nothing"
else
   echo "s3fs is NOT RUNNING for bucket $BUCKET. Remounting $BUCKET and sending notices."
   $UMOUNT $MOUNTPATH -fl >/dev/null 2>&1
   $MOUNT -a >/var/log/s3fs-watchdog.log 2>&1
   echo "s3fs for $BUCKET was not running and was restarted on `$DATE`" >> /var/log/s3fs-watchdog.log
   $RUNUSER -l ec2-user -c "$AWS_CLI ses send-email --from noreply@domain.com --destination='ToAddresses=$NOTIFY' --message 'Subject={Data=from interaktiv s3fs-watchdog,Charset=utf8},Body={Text={Data=s3fs watchdog alert,Charset=utf8},Html={Data=s3fs for $BUCKET was not running and was restarted on `$DATE`,Charset=utf8}}' --region eu-west-1"


fi


exit
