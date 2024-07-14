#!/bin/sh

set -eu

DISTRO="$(sed -n 's/^NAME="\([^"]\+\)"/\1/p' /etc/os-release)"

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

export TERMINAL=alacritty
export GTK_THEME=Adwaita:dark
export QT_QPA_PLATFORMTHEME=qt6ct
setxkbmap -layout eu

# Disable screen-saver
xset s off

# Enable DPMS to turn off displays after 10 minutes
xset dpms 600 600 600

"$HOME/.xinit-scripts/screen-layout.sh"
"$HOME/.xinit-scripts/input-devices.sh"

# Start background processes
picom &
dunst &
snixembed &
nm-applet &
pasystray -g &
solaar -w hide &

WM="i3"

if [ "$DISTRO" = "Void" ]; then
    # Setup XDG_RUNTIME_DIR
    XDG_RUNTIME_DIR="/run/user/$(id -u)"
    if [ -d "$XDG_RUNTIME_DIR" ]; then
        export XDG_RUNTIME_DIR
    fi

    # Start pipewire
    pipewire &

    # Run with a D-Bus session bus. Enable dbus service for a system bus.
    exec dbus-run-session "$WM"
else
    exec "$WM"
fi
