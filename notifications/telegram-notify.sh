#!/bin/bash
# Usage: telegram-notify.sh "message text"
source /usr/local/nagios/etc/secrets/telegram.env
curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
  -d chat_id="${CHATID}" \
  --data-urlencode text="$1" > /dev/null
exit 0
