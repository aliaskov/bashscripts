#!/bin/bash
USER="USER"
PASSWORD="PASSWORD"
HOST="HOST"
mysql -u $USER -p$PASSWORD -h $HOST --silent -e 'SELECT table_schema "DB Name", Round(Sum(data_length + index_length) / 1024 / 1024 / 1024, 1) "DB Size in Gb" FROM information_schema.tables GROUP BY table_schema;'
databases=`mysql -u $USER -p$PASSWORD -h $HOST --silent  -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`
for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump -u $USER -p$PASSWORD -h $HOST --single-transaction --order-by-primary --compress  --databases $db > `date +%Y%m%d`.$db.sql
    fi
done
