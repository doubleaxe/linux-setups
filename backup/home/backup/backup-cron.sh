#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
BACKUPS=(
    './backup-sqlite.sh "/usr/local/var/goatcounter/goatcounter.sqlite3"'
    './backup-mysql.sh "daxfb_blueprints" "1"'
    './backup-rsync.sh /root/docker name private'
)
for BACKUP in "${BACKUPS[@]}"
do
    if (sh -c "$BACKUP" >> /var/log/backup.log 2>&1) ; then
        echo "$(date +'%Y%m%d_%H%M%S') backup success" >> /var/log/backup.log
    else
        echo "$(date +'%Y%m%d_%H%M%S') backup failed" >> /var/log/backup.log
    fi
done

./cleanup.sh
