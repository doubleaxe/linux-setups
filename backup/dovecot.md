# local dovecot for private backup of large gmail mailbox

apt install dovecot-imapd
replace files in /etc/dovecot

systemctl restart dovecot
systemctl enable dovecot
systemctl status dovecot
