# CPU Performance Switch on AC/Battery

**Date:** 2026-07-28
**System:** Zorin OS, i3, AMD Ryzen 7 5800H

## Issue
CPU stuck in `powersave` governor even when plugged in. No automatic switching on AC plug/unplug.

## Root Cause
TLP running with default config had no `CPU_SCALING_GOVERNOR_ON_AC` or `CPU_SCALING_GOVERNOR_ON_BAT` set. On modern kernels TLP does not set a governor by default — it only manages `CPU_ENERGY_PERF_POLICY`. CPU stayed in `powersave` regardless of power source.

Note: running `sudo tlp bat/ac` manually locks TLP into manual mode. Use `sudo tlp start` to reset to automatic detection.

## Fix
Created `/etc/tlp.d/99-performance.conf`:
```
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_ENERGY_PERF_POLICY_ON_AC=performance
```

TLP now automatically switches governor on AC plug/unplug via udev. Verify with:
```bash
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```
