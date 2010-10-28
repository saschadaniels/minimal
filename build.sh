#!/bin/sh
BOOT_APPEND="live-config.locales=de live-config.keyboard-layouts=de"

lb clean 

lb config -p standard --memtest none --username pbx --language="de" --bootappend-live "$BOOT_APPEND" && lb build

