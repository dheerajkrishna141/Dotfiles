#!/bin/sh
# Get current volume
current=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '{print $2}' | sed 's/[^0-9]*//g')
# Increase only if below 100%
[ $current -lt 100 ] && pactl set-sink-volume @DEFAULT_SINK@ +5% || pactl set-sink-volume @DEFAULT_SINK@ 100%
# Refresh i3status
killall -SIGUSR1 i3status   
