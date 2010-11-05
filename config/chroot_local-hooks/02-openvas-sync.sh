#!/bin/sh
echo "Syncing openvas plugins\n"

/usr/sbin/openvas-nvt-sync
# Script can't restart openvas-server
# set exit code hard
exit 0
