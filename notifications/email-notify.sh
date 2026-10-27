#!/bin/bash
TO="$1"; SUBJECT="$2"; BODY="$3"
{
echo "From: K8s Nagios Alerts <k8s.nagios.alerts@gmail.com>"
echo "To: $TO"
echo "Subject: $SUBJECT"
echo
echo -e "$BODY"
} | /usr/sbin/sendmail -t -f k8s.nagios.alerts@gmail.com
