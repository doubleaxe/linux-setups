#!/bin/sh
set -eu

export database=${1}
export password=${2}
export server=${3:-remote.example.com}
export prefix=$(date +"%Y%m%d_%H%M%S")
export suffix=${database}.sql
ssh ubackup@${server} "set -o pipefail; mysqldump --single-transaction --user=${database} --password=\"${password}\" ${database} | xz -zc9" > "/home/ubackup/remote-backups/${prefix}_${suffix}.xz"
