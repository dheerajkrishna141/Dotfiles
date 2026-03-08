#!/bin/bash

FOCUSED_DISPLAY=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).output')

if [ -z "$FOCUSED_DISPLAY" ]; then
    echo "Error: Could not determine the focused display."
    exit 1
fi

xrandr --output "$FOCUSED_DISPLAY" --brightness 0

