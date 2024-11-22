#!/bin/bash
cd /root/docker
mkdir -p ../docker-backup
suffix=$(date +"%Y%m%d_%H%M%S")
tar -cjvf ../docker-backup/backup_$suffix.tar.bz2 etc var/lib/3x-ui var/lib/acme-sh var/lib/nginx .env *.env *.yaml *.sh
