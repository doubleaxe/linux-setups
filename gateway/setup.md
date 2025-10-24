# install history

apt install mc
apt update
apt upgrade
reboot
touch /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
mcedit /etc/ssh/sshd_config
```
PermitRootLogin yes
ChallengeResponseAuthentication no
PasswordAuthentication no
```
systemctl reload ssh

apt install docker.io docker-compose git curl bash openssl
docker -v
docker-compose -v
mcedit /etc/docker/daemon.json
```
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "2m",
    "max-file": "2"
  },
  "ipv6": true,
  "fixed-cidr-v6": "fd00:dead:beef::/48"
}
```

cd /usr/local/bin
curl -Lo https://github.com/robbertkl/docker-ipv6nat/releases/download/v0.4.4/docker-ipv6nat.amd64 docker-ipv6nat
chmod 755 docker-ipv6nat
mcedit /etc/systemd/system/docker-ipv6nat.service
```
[Unit]
Description=Docker IPv6-NAT
After=network.target docker.service
StartLimitIntervalSec=60

[Service]
Type=simple
Restart=on-failure
RestartSec=10
ExecStart=/usr/local/bin/docker-ipv6nat -cleanup -retry

[Install]
WantedBy=multi-user.target
```
systemctl start docker-ipv6nat
systemctl enable docker-ipv6nat
systemctl status docker-ipv6nat
reboot

apt install ufw
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 993/tcp
ufw allow 25/tcp
ufw allow 465/tcp
ufw enable
ufw status
ufw status numbered
ufw delete 3
ufw delete allow 8888/tcp

apt install fail2ban
mcedit /etc/fail2ban/jail.d/defaults-debian.conf
```
[DEFAULT]
backend = auto
maxretry = 5
findtime = 1h
bantime = 1h
banaction = ufw
banaction_allports = ufw
ignoreip = 127.0.0.1/8 172.18.0.0/16 fd12:2222:1::/64 xx.xx.xx.xx
[sshd]
enabled = true
backend = systemd
banaction = nftables-multiport
banaction_allports = nftables-allports
[dovecot]
enabled = true
logpath = /root/docker/var/log/dms/mail.log
[sieve]
enabled = true
logpath = /root/docker/var/log/dms/mail.log
[postfix]
enabled = true
mode = aggressive
logpath = /root/docker/var/log/dms/mail.log
[roundcube-auth]
enabled = true
backend = systemd
[recidive]
enabled = true
maxretry = 5
findtime = 1d
bantime = 1d
```
systemctl enable fail2ban
systemctl start fail2ban

ln -s /usr/bin/docker-compose /usr/bin/dco


# put docker behind ufw

see also https://github.com/chaifeng/ufw-docker
see also https://github.com/moby/moby/issues/4737#issuecomment-419705925

add /etc/ufw/after.rules
```
# Put Docker behind UFW, replace eth0
*filter
:DOCKER-USER - [0:0]
:ufw-user-input - [0:0]

-A DOCKER-USER -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A DOCKER-USER -m conntrack --ctstate INVALID -j DROP
-A DOCKER-USER -i eth0 -j ufw-user-input
-A DOCKER-USER -i eth0 -j DROP
COMMIT
```

add /etc/ufw/after6.rules
```
# Put Docker behind UFW, replace eth0
*filter
:DOCKER-USER - [0:0]
:ufw6-user-input - [0:0]

-A DOCKER-USER -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A DOCKER-USER -m conntrack --ctstate INVALID -j DROP
-A DOCKER-USER -i eth0 -j ufw6-user-input
-A DOCKER-USER -i eth0 -j DROP
COMMIT
```


# useful commands

systemctl status fail2ban --no-pager --full
fail2ban-client status sshd

ifconfig
ip addr show
netstat -pln -l
lsof -i -P

/root/.bashrc
```
alias mc='PROMPT_COMMAND="history -a; history -r" mc; history -r'
```

journalctl -r -n 100
journalctl -r -n 100 -u roundcube

find *.7z -print0 | xargs -0 -n1 7z l | grep -i "\.pst"


nft list ruleset
nft list table inet f2b-table


# managing docker containers

dco exec warp curl -vvv -x socks5h://127.0.0.1:1080 -sL https://cloudflare.com/cdn-cgi/trace
dco exec warp warp-cli --accept-tos status

apt install fuse gocryptfs
gocryptfs -init -plaintextnames /root/docker/private.encrypted
gocryptfs -suid -dev -exec -allow_other /root/docker/private.encrypted /root/docker/private
touch /root/docker/private/marker
fusermount -u /root/docker/private

dco up -d nginx acme.sh
dco exec acme-sh --issue -d example.com -d 2.example.com --server letsencrypt --email xxx@example.com --keylength ec-256 --standalone
dco exec acme-sh --issue -d example.com -d 2.example.com --server letsencrypt_test --email xxx@example.com --keylength ec-256 --standalone

./acme-deploy.sh example.com
./acme-deploy.sh mx.example.com mailserver /tmp/dms/custom-certs "supervisorctl restart postfix && supervisorctl restart dovecot"

dco exec nginx nginx -t
dco exec nginx nginx -s reload
./acme-deploy.sh example.com
dco exec acme-sh --remove -d example.com

./acme-deploy.sh mx.example.com mailserver /tmp/dms/custom-certs "supervisorctl restart postfix && supervisorctl restart dovecot"
dco exec dms setup help
dco exec dms setup email add user@example.com
dco exec dms setup email update user@example.com
dco exec dms setup alias add postmaster@example.com user@example.com
curl -v --url "imaps://imap.example.com/" --user "user@example.com:***" --request "STATUS INBOX (MESSAGES)"

dco exec dms setup config dkim
dco exec dms rspamadm pw
dco exec dms supervisorctl restart postfix
dig @1.1.1.1 +short TXT _dmarc.example.com
dig @1.1.1.1 +short TXT mail._domainkey.example.com
https://www.mail-tester.com/

dco exec roundcube htpasswd -B -c /data/users user1
dco exec roundcube htpasswd -B -n user1
mkdir -p /root/docker/private/lib/radicale
chown 2999:2999 /root/docker/private/lib/radicale

chmod 777 /root/docker/var/log/roundcube

htpasswd -c /root/docker/etc/nginx/conf.d/htpasswd user
htpasswd -n user

rclone config


# unmouning private dir on non-ssh logins

use /etc/profile.d/console-unmount.sh and /root/docker/unmount.sh
```
#!/bin/sh

# Skip if SSH
if [ -n "$SSH_CONNECTION" ]; then
    return 0
fi

# Skip if not root
[ "$(id -u)" -eq 0 ] || return 0

# Check if login is on a REAL console TTY (not pts/)
# Common console TTYs: tty[0-9], ttyS[0-9], hvc[0-9], xvc0, etc.
case "$(tty 2>/dev/null)" in
    /dev/tty[0-9]*|/dev/ttyS[0-9]*|/dev/hvc[0-9]*|/dev/xvc0)
        # This is a physical or VM console login
        if [ -x /root/docker/unmount.sh ]; then
            /root/docker/unmount.sh
        fi
        ;;
    *)
        # Could be sudo, su, or other — skip to avoid false positives
        return 0
        ;;
esac
```


# fetchmail

may only synchronize remote to local inbox, supports idle

`/root/docker/private/lib/dms/config/fetchmail.cf`

```
defaults
proto imap
timeout 60
#idletimeout 1200
#fetchall
no rewrite
keep

poll imap.source.com
user "remote" is "local"
pass "1"
folder "INBOX"
idle
```
