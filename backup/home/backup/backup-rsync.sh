#!/bin/sh
set -eu

export remote=${1}
export name=${2}
export private=${3:-}
export server=${4:-remote.example.com}

if [ -n "${private}" ]; then
  if ! ssh ubackup@${server} "sudo /usr/bin/test -f ${remote}/${private}/marker" ; then
    echo "Private directory is not mounted"
    exit 1
  fi
fi

rsync -a -vRO --delete --delete-during --rsync-path="sudo rsync" --exclude="private.encrypted" ubackup@${server}:"${remote}" "/home/ubackup/fpool/remote-backups-${name}"
