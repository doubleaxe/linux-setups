#!/bin/sh
set -eu

export remote=${1}
export password=${2:-password.txt}
export server=${3:-remote.example.com}
cat ${password} | ssh ubackup@${server} "[[ -f ${remote}/private/marker ]] || sudo /usr/bin/gocryptfs -suid -dev -exec -allow_other ${remote}/private.encrypted ${remote}/private"
