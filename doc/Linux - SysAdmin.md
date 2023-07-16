
# Boot partition growth management

`/etc/initramfs-tools/initramfs.conf`  should contain:
```
MODULES=dep
COMPRESS=xz
```

Then run `sudo update-initramfs -u -k all` 