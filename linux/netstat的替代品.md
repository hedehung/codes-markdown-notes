###安装
```
yum install iproute
apt-get install iproute
```

###优点
```
速度快!
```

###列出socket该要信息
```
ss -s
```

###显示所有网络打开的端口
```
ss -l
```

###现实每个进程具体打开的socket
```
ss -pl
```

###显示所有打开的tcp socket 
```
ss -t -a
```

###显示所有打开的udp socket 
```
ss -d -a
```

###显示已经建立的SMTP连接
```
ss -o state established '( dport = :http or sport = :smtp )'
```

###显示已经建立的HTTP连接
```
ss -o state established '( dport = :http or sport = :http )'
```
