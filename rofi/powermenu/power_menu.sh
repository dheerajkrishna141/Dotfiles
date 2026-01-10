#!/usr/bin/env bash

chosen=$(printf "Power Off\nRestart\nSuspend\nLog Out" | rofi -dmenu -i -theme-str '@import "powermenu/power.rasi"')

case "$chosen" in
	"Power Off") systemctl poweroff ;;
	"Restart") systemctl reboot ;;
	"Suspend") systemctl suspend ;;
	"Log Out") i3-msg exit ;;
	# "Lock") i3lock ;;
	*) exit 1 ;;
esac
