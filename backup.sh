#!bin/bash
#
backupdir=("/opt" "/home/ec2-user")
#
backuplocation="/backup"

mkdir -p "$backuplocation"

for dir in "${backupdir[@]}"
do
backupfile="$bacuplocation/$(baename $dir")_backup_$(date +Y-%m-%d).tar.gz"
tar -czf "$backupfile" "$dir"