###查看进程的host列
```
mysql> show processlist;
```
或者是
```
mysqladmin -uroot processlist;
```
host列中会出现远程发起的端口，假设是37636。
```
netstat -ntp | grep :37636
tcp 0 0 192.168.0.12:37636 192.168.0.21:3306 ESTABLISHED 16072/apache2
```
再查询同类的其他的连接
```
netstat -ntp | grep 16072/apache2
```
列出他打开的所有文件
```
lsof -i -P | grep 16072
```
