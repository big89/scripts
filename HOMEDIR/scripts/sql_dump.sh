#!/bin/bash
# $HOMEDIR/scripts/sql_dump
#
# Dump MySQL & PostgreSQL databases for backup
#
dumpdir="/data/backups"
timestamp=`date +"%Y-%m-%d_%H:%M"`

## MySQL
for db in `mysql -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`
do
	# Skip some databases
	if [ ${db} = "information_schema" ]
	then
		continue
	fi
	
	# Dump DB, run through gzip, save to file
	mysqldump -eq -h localhost ${db} | gzip -c - > "${dumpdir}/mysql/${db}_${timestamp}.sql.gz"
	
done

## Postgres
for db in `psql -l | grep en_US | cut -d "|" -f 1`
do
	# Skip some databases
	if [ ${db} = "template0" ]
	then
		continue
	fi
	
	# Dump DB, run through gzip, save to file
        pg_dump ${db} | gzip -c - > "${dumpdir}/postgres/${db}_${timestamp}.sql.gz"
	
done

## Clean out old dumps
find ${dumpdir}/mysql/ -type f -mtime +14 -exec rm {} \;
find ${dumpdir}/postgres/ -type f -mtime +14 -exec rm {} \;

unset dumpdir timestamp db
