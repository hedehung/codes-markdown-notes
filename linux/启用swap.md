###创建大小512M的交换分区

```
dd if=/dev/zero of=/var/swap bs=1024 count=512000  
/sbin/mkswap /var/swap 
/sbin/swapon /var/swap
```

###编辑fstab

```
sudo vim /etc/fstab
/var/swap swap swap defaults 0 0
```