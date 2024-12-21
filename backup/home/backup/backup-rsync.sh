#!/bin/sh
set -eu

export remote=${1}
export name=${2}
export server=${3:-remote.example.com}
rsync -avR -r --delete --delete-during --rsync-path="sudo rsync" --exclude="private.encrypted" ubackup@${server}:"${remote}" "/home/ubackup/remote-backups-${name}"
