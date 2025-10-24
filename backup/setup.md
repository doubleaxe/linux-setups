# backup

## backup target server

apt install rsync
#groupadd -g 801 backup
useradd -g backup -m -s /bin/bash -u 801 ubackup
su ubackup
ssh-keygen -t ed25519 -C "backup"
cat /home/ubackup/.ssh/id_ed25519.pub
#ssh-keygen -t rsa -b 2048 -C "backup-rsa"
#cat /home/ubackup/.ssh/id_rsa.pub
touch /var/log/backup.log
chown ubackup:backup /var/log/backup.log
chmod 664 /var/log/backup.log

## source server

apt install rsync sudo
#groupadd -g 801 backup
useradd -g backup -m -s /bin/bash -u 801 ubackup
#passwd ubackup
#passwd --delete ubackup
#adduser ubackup sudo
#deluser ubackup sudo
```
echo "ubackup ALL=NOPASSWD:/usr/bin/rsync, /usr/bin/gocryptfs, /usr/bin/test, CWD=/root/docker /usr/bin/docker-compose" > /etc/sudoers.d/ubackup-rsync
chmod 440 /etc/sudoers.d/ubackup-rsync
```
su ubackup
mcedit ~/id_ed25519.pub
#mcedit ~/id_rsa.pub
mkdir -p ~/.ssh
cat ~/id_ed25519.pub >> ~/.ssh/authorized_keys
#cat ~/id_rsa.pub >> ~/.ssh/authorized_keys
exit

## backup target server

mcedit ~/backup-cron.sh
```
#!/bin/sh
if (/home/ubackup/backup.sh >> /var/log/backup.log 2>&1) ; then
  echo "$(date +'%Y%m%d_%H%M%S') backup success" >> /var/log/backup.log
else
  echo "$(date +'%Y%m%d_%H%M%S') backup failed" >> /var/log/backup.log
fi
```
mcedit ~/backup.sh
```
#!/bin/sh
set -eu
mkdir -p /home/ubackup/remote-backups
rsync -avR -r --delete --delete-during --rsync-path="{ echo <SUDOPASS>; cat; } | sudo -S rsync" --exclude="private.encrypted" ubackup@example.com:"/root/docker" "/home/ubackup/remote-backups"
```
chmod 755 ~/backup-cron.sh
chmod 755 ~/backup.sh

## zfs

mcedit /etc/apt/sources.list.d/buster-backports.list
```
deb http://archive.debian.org/debian buster-backports main contrib
deb-src http://archive.debian.org/debian buster-backports main contrib
```
apt update
apt list -a zfsutils-linux
apt install zfsutils-linux=2.0.3-9~bpo10+1

mkdir -p /pool/debian-local
truncate -s 20G /pool/backup.pool

/usr/sbin/zpool create -o ashift=12 -o feature@hole_birth=disabled -o feature@encryption=disabled -o feature@multi_vdev_crash_dump=disabled -O compression=zstd-5 -O casesensitivity=sensitive -O atime=off -O normalization=formC -O utf8only=on -O xattr=sa -O dnodesize=auto -O canmount=noauto -O readonly=on fpool /pool/backup.pool

sudo zfs create -o readonly=off -o canmount=noauto -o mountpoint=/pool/debian-local fpool/debian
sudo zfs mount fpool/debian
mkdir -p /pool/debian-local/ubackup
chown ubackup:backup /pool/debian-local/ubackup
ln -s /pool/debian-local/ubackup /home/ubackup/fpool

tar cfJ remote-backups.tar.xz remote-backups
tar cf - remote-backups/ | xz -zc9 -T0 - > remote-backups.tar.xz

## restore backup to remote

rsync --dry-run -e "ssh -o "IdentitiesOnly=yes" -i "/Volumes/pool/debian/ubackup/usr/home/ubackup/.ssh/id_ed25519"" -a -vO --ignore-existing --rsync-path="sudo rsync" --exclude="var/log" "./remote-backups-aeza/root/docker/" ubackup@77.239.99.31:"/root/docker/"
