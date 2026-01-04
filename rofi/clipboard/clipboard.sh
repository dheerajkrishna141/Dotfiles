#!/bin/bash

# Change this path to the new file you created
THEME="$HOME/.config/rofi/clipboard/clipboard.rasi"

rofi -modi "clipboard:greenclip print" \
     -show clipboard \
     -run-command '{cmd}' \
     -theme "$THEME"
