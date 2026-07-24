This is no issue, just logging how I disabled IPv6 on my System.


I updated the GRUB configuration to disable IPv6 by adding the following line to the GRUB_CMDLINE_LINUX_DEFAULT variable in /etc/default/grub:

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash ipv6.disable=1"

```

After making this change, I updated the GRUB configuration by running the following command:

```
sudo update-grub
```
That's it done! After rebooting, IPv6 should be disabled on your system. You can verify that IPv6 is disabled by running the following command:

```
ip -6 addr
```
