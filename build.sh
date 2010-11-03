#!/bin/sh
BOOT_APPEND="live-config.locales=de live-config.keyboard-layouts=de"

lb clean 

lb config -p minimal --memtest none --username pentest --language="de" --bootappend-live "$BOOT_APPEND" && lb build

