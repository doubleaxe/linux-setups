#!/bin/sh
set -eu

find /home/ubackup/remote-backups -type f \( -name '*.xz' -o -name '*.gz' \) -mtime +300 -exec rm {} \;
find /home/ubackup/remote-backups -type f \( -name '*.xz' -o -name '*.gz' \) -mtime +30 | grep -v '_0000' | xargs -r rm
