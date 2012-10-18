###要操作数据库首先得停止数据库进程
```
$sudo /etc/init.d/mysql stop
```
###将原有数据库转移到新位置
```
$sudo cp –R –p /var/lib/mysql /home/mysql
```
###编辑MySQL配置文件
```
$sudo vi /etc/mysql/my.cnf #找到datadir这一行，将后面等于号之后的内容更改为/home/mysql然后保存退出
```

Ubuntu就开始使用一种安全软件叫做AppArmor，这个安全软件会在你的文件系统中创建一个允许应用程序访问的区域（专业术语：应 用程序访问控制）。如果不为MySQL修改AppArmor配置文件，永远也无法为新设置的数据库存储位置启动数据库服务。

###配置AppArmor
```
$sudo vi /etc/apparmor.d/usr.sbin.mysqld 
```
找到/var/lib/mysql/这两行，注释掉这两行，在这两行前分别添加一个符号“#”即可注释，在这两行之前或之后加上下面内容
```
/home/mysql/ r,
/home/mysql/** rwk,
```
###保存后退出，执行命令
```
$sudo /etc/init.d/apparmor reload
```
###重启MySQL服务
```
$sudo /etc/init.d/mysql start
```

###注意
* 数据库新位置需要绝对路径，不能做软链接
* 数据文件夹的用户组为mysql，mysql的根目录权限需要为root权限
