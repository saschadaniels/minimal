#!/bin/sh
#PACKAGES="shorewall"
BOOT_APPEND="live-config.locales=de live-config.keyb=de"



lb clean 

lb config  --memtest none --username pbx --bootappend-live "$BOOT_APPEND" && lb build


