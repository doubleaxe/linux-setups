#!/bin/bash
set -eu
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
export prefix=$(date +"%Y%m%d_%H%M%S")
sudo -H -u ubackup ./backup-cron.sh
sudo zfs snapshot fpool/debian@auto-${prefix}

#cleanup
sudo zfs list -H -t snapshot -o name -S creation | grep '^fpool/debian@auto-' | grep -v '01_0000' | tail -n +30 | xargs --no-run-if-empty -n1 zfs destroy -r
