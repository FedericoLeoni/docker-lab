#!/bin/bash

DATA=$(date +%F_%H-%M)

DEST1="backupuser@192.168.1.xxx:/mnt/pool1/backup/db"
DEST2="backupuser@192.168.1.xxx:/mnt/pool1/backup/docker"

docker exec crm-db \
  mysqldump -u root -pxxxxx espocrm > /tmp/db_$DATA.sql

tar czf /tmp/docker_$DATA.tar.gz /root/docker-lab/docker

rsync -avz /tmp/db_$DATA.sql $DEST1/
rsync -avz /tmp/docker_$DATA.tar.gz $DEST2/

ssh backupuser@192.168.1.xxx "
  cd /mnt/pool1/backup/db &&
  ls -1t db_*.sql | tail -n +4 | xargs -r rm --
"

ssh backupuser@192.168.1.xxx "
  cd /mnt/pool1/backup/docker &&
   ls -1t docker_*.tar.gz | tail -n +4 | xargs -r rm --
"

rm /tmp/db_$DATA.sql
rm /tmp/docker_$DATA.tar.gz

