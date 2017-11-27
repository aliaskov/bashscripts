#!/bin/bash
INSTANCE_ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
VOLUME_ID=vol-054914c6b50b19a9c


#Check devices and mapping
#aws ec2 describe-volumes --region eu-west-1 --filters Name=attachment.instance-id,Values=$INSTANCE_ID --query 'Volumes[*].Attachments[*].{VolumeId:VolumeId,DeviceMapping:Device}' --output text

#Type ID and mount
#aws ec2 describe-volumes --region eu-west-1 --filters Name=attachment.instance-id,Values=i-01038c9bddee62cf8 --query 'Volumes[*].{Type:VolumeType,ID:VolumeId,Mounted_as:Attachments[*].Device}' --output text


VOL_STATE=`aws ec2 describe-volumes --volume-ids $VOLUME_ID --region eu-west-1 --query 'Volumes[0].State' --output text`
if [ $VOL_STATE = in-use ]; then
    aws ec2 detach-volume --force --volume-id $VOLUME_ID --region eu-west-1
fi
aws ec2 wait volume-available --volume-ids $VOLUME_ID --region eu-west-1
if [ ! -e /dev/sdk ]
then
    aws ec2 attach-volume --volume-id $VOLUME_ID --instance-id $INSTANCE_ID --device /dev/sdk --region eu-west-1
    while [ ! -e /dev/sdk ]; do sleep 5; done
fi
if ! blkid /dev/sdk
then
    mkfs.ext4 /dev/sdk
fi
mkdir -p /data
if ! grep -qs '/data' /proc/mounts
then
    mount /dev/sdk /data
fi
