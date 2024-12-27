options.timeout = 30
options.subscribe = true

account = IMAP {
    server = "imap.example.com",
    username = "email@example.com",
    password = "1",
    port = 993,
    ssl = "tls1"
}

while true do
    if not account.INBOX:enter_idle() then
        print("IDLE not supported")
        break
    end
    -- pipe_to("mbsync -c ~/mbsyncrc --push-new slave1:INBOX", "")
    pipe_to("systemctl start mbsync.service", "")
    print("synchronized account messages")
    sleep(30)
end
