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
