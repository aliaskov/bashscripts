#!/bin/bash

USER="USER"
PASSWORD="PASSWORD"
HOST="HOST"

FILES="/data/backup/dumps/*.sql"

for f in $FILES
do
  echo "Processing $f file..."
  mysql -h $HOST -u $USER -p$PASSWORD < $f
done
