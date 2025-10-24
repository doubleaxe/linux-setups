#!/bin/sh

cd /root/docker
dco stop -t 2 dms apache radicale roundcube daxfb_blueprints  > /dev/null 2>&1
fusermount -u ./private > /dev/null 2>&1
