#!/bin/sh
BOOT_APPEND="live-config.locales=de live-config.keyb=de"

lb clean 

lb config -p standard --memtest none --username pbx --bootappend-live "$BOOT_APPEND" && lb build

