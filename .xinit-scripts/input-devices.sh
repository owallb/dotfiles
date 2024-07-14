#!/usr/bin/env sh

touchpad_id=$(xinput list | grep -i 'touchpad' | grep -oE 'id=[0-9]+' | cut -d= -f2)

if [ -z "$touchpad_id" ]; then
    echo "Touchpad not found." >&2
    exit 1
fi

xinput set-prop "$touchpad_id" "libinput Tapping Enabled" 1
xinput set-prop "$touchpad_id" "libinput Natural Scrolling Enabled" 1

