
# Boot partition growth management

`/etc/initramfs-tools/initramfs.conf`  should contain:
```
MODULES=dep
COMPRESS=xz
```

Then run `sudo update-initramfs -u -k all` 

# Cleanup old kernels
```bash
# removes old kernels and cleans up space.
dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'`uname -r`'/q;p' | xargs sudo apt-get -y purge
```