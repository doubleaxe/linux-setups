#!/bin/sh
set -eu

export remote=${1}
export password=${2:-password.txt}
export server=${3:-remote.example.com}

export private=private

if ssh ubackup@${server} "sudo /usr/bin/test ! -f ${remote}/${private}/marker" ; then
    cat ${password} | ssh ubackup@${server} "sudo /usr/bin/gocryptfs -suid -dev -exec -allow_other ${remote}/${private}.encrypted ${remote}/${private}"
fi
