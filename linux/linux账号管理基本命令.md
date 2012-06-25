###/etc/passwd的结构
```
username:password:uid:gid:comment:home_dir:login:shell
```
###/etc/shadow(存储加密形式的密码)的结构
```
username:password:lastchanged:mindays:maxdays:warn:inactive:expire:reserve
```
###添加和删除账号
```
useradd -m ubuntu #-m参数表示创建用户的主目录
userdel ubuntu 
```
###更换用户的shell
```
sudo usermod -s /bin/ksh ubuntu #mac使用chsh(change shell)
```
###封锁账号
在/etc/passwd文件相应账号的密码字段加星号*
###更改密码
```
passwd #更改当前用户密码
sudo passwd ubuntu #更改用户ubuntu的密码
```
###强制ubuntu用户下次登陆更改密码
```
sudo passwd -e ubuntu
```
###锁定用户
```
sudo passwd -l ubuntu
```
###查询当前用户的id信息
```
whoami
id
```
###查看组信息
```
cat /etc/group
```
###增加gid=2000的名为xxx的组
```
sudo groupadd -g 200 xxx
```
###修改和删除用户组
```
groupmod
groupdel
```
###增加用户xxx并且增加一个组xxx
```
sudo useradd -u 1002 -d /home/xxx/ -m -s /bin/bash xxx
```
###修改组
```
vim /etc/group
```
###把用户踢出组
```
sudo gpasswd -d ubuntu admin 或
sudo vim /etc/passwd 找到用户的那行把定义的组删除掉
```
###查询活动用户
```
who -Ha
```
###查询注册到系统中的用户
```
finger
```
###查询用户活动
```
w
```
###向注册用户发送通知
```
wall #write to all
```
###命令权限控制
```
sudo visudo
```
###切换用户
```
su
su root
su ubuntu
```
###登陆认证
```
ssh-keygen
```
