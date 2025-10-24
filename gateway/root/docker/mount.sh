#!/bin/sh

gocryptfs -suid -dev -exec -allow_other /root/docker/private.encrypted /root/docker/private
