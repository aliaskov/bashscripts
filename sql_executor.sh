#!/bin/bash

# Don't forget to start this script in screen mode

USER="root"
PASSWORD="PASS"
HOST="HOST"

#FILES="/data/backup/dumps/*.sql"

SCRIPTS="*.sql"


for s in $SCRIPTS
do
  echo "Processing $s ... " 
  mysql -h $HOST -u $USER -p$PASSWORD --verbose < $s
done
echo "Done"
date
