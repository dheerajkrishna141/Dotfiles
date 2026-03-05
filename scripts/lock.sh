#!/bin/bash

# Path to your desired background image (can be jpg or png)
IMAGE="/home/kratosfury/Pictures/Background_images/lock_screen_1_scaled.png" 

# Temporary file for the scaled image (i3lock requires a PNG)
LOCK_IMG="/tmp/current_lock.png"

# Get the current total dimensions of all active screens combined
RES=$(xdpyinfo | grep dimensions | awk '{print $2}')

# Scale and crop the image to fill the total resolution without stretching
convert "$IMAGE" -resize "$RES^" -gravity center -extent "$RES" "$LOCK_IMG"

# Execute i3lock with the freshly generated image
i3lock -i "$LOCK_IMG" "$@"
