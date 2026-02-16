#!/bin/bash
while true; do
  if pactl list sinks | grep -q "State: RUNNING"; then
    # Tell X11 and the screensaver to reset their idle timers
    xset s reset
    xdg-screensaver reset
  fi
  # Check every 60 seconds (no need to be too aggressive)
  sleep 60
done
