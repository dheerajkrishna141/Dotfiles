# Slow Shutdown Troubleshoot Log

**Date:** 2026-07-23
**System:** Zorin OS, hybrid graphics (AMD Radeon Vega iGPU + NVIDIA RTX 3050 Mobile dGPU), driver `nvidia-driver-580-open` 580.159.03, kernel 7.0.0-28-generic

## Issue
Shutdown/poweroff was taking noticeably longer than expected, on top of (and separate from) the earlier i3 boot delay.

## Root Cause
`nvidia-persistenced.service` does not exit cleanly on SIGTERM. systemd waits the full default `TimeoutStopSec` (90s) before force-killing it with SIGKILL, adding ~90s to every shutdown.

This is tied to RTD3 (Runtime D3) fine-grained power management: the NVIDIA dGPU suspends itself when idle to save battery, and `nvidia-persistenced` doesn't handle the daemon-to-suspended-GPU handoff cleanly at shutdown. This is a known, long-standing upstream issue reported across many driver versions (390, 470, 515, 525, 530, 580) and multiple hybrid-graphics laptops — not something specific to this machine, though a recent driver/kernel update likely shifted GPU power behavior enough to newly trigger it here.

## Troubleshooting Steps
1. `journalctl -b -1 | grep -i "timed out"` — found `nvidia-persistenced.service: State 'stop-sigterm' timed out. Killing.`
2. `journalctl -b -1 --no-pager -o short-precise | grep -i persistenced` — confirmed exact 90s gap between "Stopping..." and "timed out. Killing."
3. `lspci -k | grep -iE "vga|3d|display"` — confirmed hybrid graphics setup (NVIDIA RTX 3050 dGPU + AMD Vega iGPU), so the service is legitimately needed (not a leftover/unused driver).
4. `cat /proc/driver/nvidia/gpus/*/power` — confirmed `Runtime D3 status: Enabled (fine-grained)`, i.e. dGPU actively runtime-suspending.
5. Checked driver version (`nvidia-smi`, `apt list --installed`) and searched for known issues — confirmed this is a widely-reported, unresolved upstream bug rather than a config error, so no clean version-based fix exists.

## Fix
Reduce the stop timeout so systemd doesn't wait out the full 90s for a shutdown that won't complete cleanly anyway:
```bash
sudo systemctl edit nvidia-persistenced.service
```
Add:
```ini
[Service]
TimeoutStopSec=5
```
Then:
```bash
sudo systemctl daemon-reload
```

This is a workaround, not an upstream fix — persistence mode itself is preserved for GPU compute use; only the shutdown wait is shortened.

## Preventing Recurrence
No permanent upstream fix currently exists for this driver/RTD3 interaction. If a future NVIDIA driver update resolves it, the `TimeoutStopSec` override can be safely removed by deleting the override file:
```bash
sudo systemctl revert nvidia-persistenced.service
```
