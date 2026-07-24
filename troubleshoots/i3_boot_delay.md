# i3 Slow Boot Troubleshoot Log

**Date:** 2026-07-23
**System:** Zorin OS, i3 (via gdm3), AMD GPU

## Issue
i3 session boot time increased to ~3 minutes. GNOME session on the same machine booted normally. Shutdown/poweroff was also slower than normal.

## Root Cause
`/etc/X11/Xsession.d/90xbrlapi` runs `xbrlapi` during X session setup to connect to the `brltty` (braille display) daemon. `brltty.service` was disabled/not running, and `xbrlapi` did not fail fast on connection refusal — it retried internally for **~2m14s** before giving up. This script runs as part of the generic X11 session chain (used by i3), but not as part of GNOME's session startup, which explains why only i3 was affected.

## Troubleshooting Steps
1. `systemd-analyze blame` / `systemd-analyze critical-chain` — confirmed systemd boot itself completed in ~20s; delay was not in early boot.
2. Checked `journalctl -b` for timeouts — none found.
3. Instrumented `~/.config/i3/config` and autostart (`dex`) with timestamps in `/tmp/i3-timing.log` — showed i3's own startup + autostart apps completed in <200ms once i3 itself launched.
4. Compared `systemd-logind` session-open timestamp vs. `i3 start` timestamp in the timing log — isolated a ~133s silent gap occurring *before* i3 launched.
5. Reviewed `journalctl -b` across that exact time window — no log output during the gap (silent hang), narrowing it to the `/etc/X11/Xsession.d/` script chain.
6. Identified `90x11-common_ssh-agent` as the last script to log, with the next script alphabetically being `90xbrlapi`.
7. Reproduced the hang directly: `time xbrlapi -b1` → confirmed 2m14s before `Connection refused`.

## Fix
`chmod -x` on the script did **not** work — Xsession sources scripts by checking readability, not the executable bit, so it still ran.

Actual fix: remove the script from the directory so it's not sourced at all:
```bash
sudo mv /etc/X11/Xsession.d/90xbrlapi /root/90xbrlapi.bak
```

Rebooted into i3 — boot time returned to normal.

## Preventing Recurrence
Leave `90xbrlapi` moved out of `/etc/X11/Xsession.d/` unless a braille display is actually needed; if braille support is needed later, either enable/start `brltty.service` first or reinstall/restore the script only after confirming the daemon runs, and avoid reinstalling `brltty`/`xbrlapi` packages without also enabling the service.
