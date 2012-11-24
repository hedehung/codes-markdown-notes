###开启80端口
```
socat - tcp:127.0.0.1:80
#相当于
nc 127.0.0.1 80
```

###把cmd綁定到端口23,把cmd的stderr重定向到stdout
```
socat tcp-listen:23 exec:cmd,pty,stderr
#客户端获得shell
socat readline tcp:server:23 
```

###传输文件 
```
#host1
socat -u open:myfile.exe,binary tcp-listen:999
#host2 
socat -u tcp:host1:999 open:myfile.exe,create,binary
#文件传输结束可自动退出(nc不行)
```

###NAT环境,外部的9000映射到内部的9000
```
#外部端口 
socat tcp-listen:1234 tcp-listen:9000
#内部
socat tcp:outerhost:1234 tcp:192.168.12.34:9000
```

###读写分流
```
#客戶端連過來之後,就把read.txt裡面的內容發過去,同時把客戶的數據保存到write.txt裡面
socat open:read.txt!!open:write.txt,create,append tcp-listen:80,reuseaddr,fork
```

[参考官方样例](http://www.dest-unreach.org/socat/doc/socat.html#EXAMPLES)
