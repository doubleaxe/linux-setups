# local dovecot for private backup of large gmail mailbox

apt install dovecot-imapd dovecot-lmtpd
replace files in /etc/dovecot

systemctl restart dovecot
systemctl enable dovecot
systemctl status dovecot
