#问题

```
mkdir test
mkdir: cannot create directory `test': Read-only file system
```

#处理

```
umount /mnt/
// umount: /mnt: device is busy

fuser -m /dev/sda3
// 把列出来的进程kill掉

umount /mnt/
// 执行磁盘检查
fsck -V -a /dev/xvdb
mount /mnt/
```