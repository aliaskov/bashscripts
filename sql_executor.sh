#!/bin/bash

# start this script in screen mode, plus add 2>$1 > output.log

USER="root"
PASSWORD="PASS"
HOST="HOST"

#FILES="/data/backup/dumps/*.sql"

SCRIPTS="*.sql"


for s in $SCRIPTS
do
  echo "Processing $s ... " \
  mysql -h $HOST -u $USER -p$PASSWORD --verbose < $s
done
echo "Done"
date
