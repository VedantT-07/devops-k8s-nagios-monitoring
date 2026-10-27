#!/bin/bash
# Usage: telegram-notify.sh "message text" [chat_id]
source /usr/local/nagios/etc/secrets/telegram.env
TARGET="${2:-$CHATID}"
curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
  -d chat_id="${TARGET}" \
  --data-urlencode text="$1" > /dev/null
exit 0
