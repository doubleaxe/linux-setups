
# imapsync

brew install imapsync
apt install imapsync

imapsync --dry --host1 imap.source.com --user1 source@source.com --passfile1 1.txt --authmech1 LOGIN --host2 imap.example.com --user2 email@example.com --passfile2 2.txt --authmech2 LOGIN --ssl1 --ssl2 --skipemptyfolders --folderrec Inbox --subfolder2 Archive

curl -LO https://imapsync.lamiral.info/oauth2/oauth2_imap.zip
unzip oauth2_imap.zip
cd oauth2_imap
cpan install Mail::IMAPClient
cpan install Email::Address
cpan -f -i -T HTTP::Daemon::SSL
perl oauth2_imap --provider gmail user@gmail.com

imapsync --dry --host1 imap.gmail.com --user1 user@gmail.com --passfile1 1.txt --oauthaccesstoken1 1t.txt --host2 imap.example.com --user2 email@example.com --password2 12qw --authmech2 LOGIN --ssl1 --skipemptyfolders --subscribed --noautomap --useheader "Message-Id" --useheader Date --useheader Subject --useheader From --useheader To --useheader Cc --maxbytespersecond 300_000

--gmail1 implies folder remapping even with --noautomap, must be removed for exact copy
--skipcrossduplicates

# imapdedup

brew install pipx
pipx install imapdedup
PATH="~/.local/bin:$PATH"

imapdedup -s imap.example.com -u "email@example.com" -x -l
imapdedup -s imap.example.com -u "email@example.com" -x -n "INBOX"
imapdedup -s imap.example.com -u "email@example.com" -x -d "INBOX"
imapdedup -s imap.example.com -u "email@example.com" -x -d -y "Trash" "INBOX"

imapdedup -s imap.example.com -u "email@example.com" -x -n -r -R "INBOX"
imapdedup -s imap.example.com -u "email@example.com" -x -d -r -R "INBOX"

imapdedup -s imap.example.com -u "email@example.com" -x -l
imapdedup -s imap.example.com -u "email@example.com" -x -d -R "INBOX" "INBOX/Folder"

imapdedup -s imap.example.com -u "email@example.com" -x -l | sort -r | tr '\n' '\0' | xargs -0 sh -c 'imapdedup -s imap.example.com -u "email@example.com" -x -m -c -n "$@"' _
imapdedup -s imap.example.com -u "email@example.com" -x -l | grep -e '^INBOX' -e '^Sent' | sort -r | tr '\n' '\0' | xargs -0 sh -c 'imapdedup -s imap.example.com -u "email@example.com" -x -m -c -n "$@"' _

# mdedup

curl -L -O https://github.com/kdeldycke/mail-deduplicate/releases/latest/download/mdedup-macos-x64.bin
curl -L -O https://github.com/kdeldycke/mail-deduplicate/releases/latest/download/mdedup-linux-x64.bin
curl -L -O https://github.com/kdeldycke/mail-deduplicate/releases/latest/download/mdedup-windows-x64.exe

brew install pipx
pipx install mail-deduplicate

see https://kdeldycke.github.io/mail-deduplicate/index.html
doesn't work with IMAP, only maildir/mbox

# imapfilter

For running command on IMAP IDLE.

brew install imapfilter
apt install imapfilter

imapfilter -V

imapfilter -e 'account=IMAP{server="imap.example.com",username="email@example.com",password="1",port=993,ssl="tls1"};mailboxes,folders=account:list_all();print(table.concat(mailboxes,";"));print(table.concat(folders,";"))'

imapfilter -v -c account.lua

systemctl daemon-reload
systemctl start imapfilter@account.service
systemctl enable imapfilter@account.service
systemctl start mbsync.timer
systemctl enable mbsync.timer
systemctl list-timers

# isync

brew install isync
apt install isync

curl -L -o isync-1.5.0.tar.gz https://sourceforge.net/projects/isync/files/isync/1.5.0/isync-1.5.0.tar.gz/download
tar -xzvf isync-1.5.0.tar.gz
apt install libzlib-dev libssl-dev libdb-dev
./configure --prefix=/usr/local
make
sudo make install

mbsync --version
config - pre 1.3.0 or post 1.5.0

mbsync -c ~/mbsyncrc --list-stores -a
mbsync -c ~/mbsyncrc --dry-run -a
mbsync -c ~/mbsyncrc -l -a
mbsync -c ~/mbsyncrc -a
mbsync -c ~/mbsyncrc -aV -Ds

# offlineimap

apt install offlineimap3
brew install offlineimap

brew install pipx
pipx install offlineimap

Supports IDLE, can synchronize remote to local, or two ways. Much more complex than isync.

# fetchmail

apt install fetchmail
chmod 600 ./fetchmailrc
openssl s_client -connect server.example.com:995 -showcerts
openssl x509 -in server.example.com.pem -outform DER | openssl md5 -c

mkdir -p /root/fetchmail/ssl/certs
cp server.example.com.pem /root/fetchmail/ssl/certs/
c_rehash /root/fetchmail/ssl/certs/

export OPENSSL_CONF=/root/fetchmail/openssl.cnf
fetchmail -f ./fetchmailrc --sslcertpath "/root/fetchmail/ssl/certs/" -v
