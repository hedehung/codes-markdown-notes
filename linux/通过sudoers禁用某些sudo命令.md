###编辑 sudoers文件
```
sudo visudo
```

###编辑内容
```
Defaults	env_reset
Defaults 	logfile="/var/log/sudo.log"
Cmnd_Alias DENY_CMD=!/usr/sbin/useradd,!/usr/sbin/userdel,!/usr/sbin/usermod -*,!/usr/bin/passwd [A-Za-z]*,!/usr/bin/passwd root,!/usr/sbin/usermod -* root

# User privilege specification
root	ALL=(ALL) ALL
账号  ALL=(ALL) NOPASSWD: ALL,DENY_CMD
```

为了禁止编辑sudoers文件，可以禁用/etc/sudoers文件，命令是/usr/sbin/visudo.
