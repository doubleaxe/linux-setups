options.timeout = 30
options.subscribe = true

account = IMAP {
    server = "imap.example.com",
    username = "email@example.com",
    password = "1",
    port = 993,
    ssl = "tls1"
}

function custom_idle(mbox)
    if #mbox:is_unseen() == 0 then
        if not mbox:enter_idle() then
            sleep(300)
        end
    end
end

while true do
    custom_idle(account.INBOX)
    -- pipe_to("mbsync -c ~/mbsyncrc --push-new slave1:INBOX", "")
    pipe_to("systemctl start mbsync.service", "")
    unseen = account.INBOX:is_unseen()
    unseen:mark_seen()
    print("synchronized account messages " .. #unseen)
end
