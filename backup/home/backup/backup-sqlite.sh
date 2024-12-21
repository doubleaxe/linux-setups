#!/bin/sh
set -eu

export file=${1}
export server=${2:-remote.example.com}
export prefix=$(date +"%Y%m%d_%H%M%S")
export suffix=$(basename -- "${file}")
ssh ubackup@${server} "sqlite3 \"${file}\" .dump | xz -zc9" > "/home/ubackup/remote-backups/${prefix}_${suffix}.xz"
