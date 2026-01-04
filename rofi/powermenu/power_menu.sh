#!/usr/bin/env bash

chosen=$(printf "Power Off\nRestart\nSuspend\nLock" | rofi -dmenu -i -theme-str '@import "powermenu/power.rasi"')

case "$chosen" in
	"Power Off") systemctl poweroff ;;
	"Restart") systemctl reboot ;;
	"Suspend") systemctl suspend ;;
	"Lock") i3lock ;;
	*) exit 1 ;;
esac
