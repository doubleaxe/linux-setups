# install history

apt install mc
apt update
apt upgrade
reboot
touch /root/authorized_keys
chmod 600 /root/authorized_keys
mcedit /etc/ssh/sshd_config
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
  }
}
```
reboot

apt install ufw
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
ufw status

apt install fail2ban
mcedit /etc/fail2ban/jail.d/defaults-debian.conf
```
[sshd]
enabled = true
backend = systemd
maxretry = 6
findtime = 1h
bantime = 1h
ignoreip = 127.0.0.1/8 xx.xx.xx.xx
```
systemctl enable fail2ban
systemctl start fail2ban

ln -s /usr/bin/dco docker-compose

# useful commands

curl -vvv -x socks5h://127.0.0.1:40000 -sL https://cloudflare.com/cdn-cgi/trace

systemctl status fail2ban --no-pager --full
fail2ban-client status sshd

ifconfig
ip addr show
netstat -pln -l
lsof -i -P

alias mc='PROMPT_COMMAND="history -a; history -r" mc; history -r'

journalctl -r -n 100


# managing docker containers

dco up -d nginx acme.sh
dco exec acme.sh --issue -d example.com -d additional.com --server letsencrypt --email xxx@xxx.xxx --keylength ec-256 --standalone
dco exec acme.sh --issue -d example.com -d additional.com --server letsencrypt_test --email xxx@xxx.xxx --keylength ec-256 --standalone

dco exec nginx nginx -s reload
./acme-deploy.sh example.com
dco exec acme.sh --remove -d example.com
