#!/bin/sh
set -e # Exit if any command fails
# Check if there are any bounce/failure/error messages that might be worth knowing about
# and email the report to admins.

tmpfile=/tmp/pflogsumm-notice.txt
to_address=postmaster,info@ceresfairfood.org.au

/usr/sbin/pflogsumm -d yesterday -u 0 --problems-first --verbose-msg-detail /var/log/mail.log > $tmpfile

if egrep -m1 -q "(by relay\)|(reject|hold|discard) detail|failures|Warnings|Errors|Panics)$" $tmpfile; then
  mailx -s "Email error stats: `uname -n`" $to_address < $tmpfile
fi