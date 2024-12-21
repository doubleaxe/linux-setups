#!/bin/sh
set -eu

find /home/ubackup/remote-backups -type f -name '*.xz' -mtime +100 -exec rm {} \;
find /home/ubackup/remote-backups -type f -name '*.xz' -mtime +30 | grep -v '_0000' | xargs -r rm
