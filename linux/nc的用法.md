###侦听端口
```
nc -l 9000
#连接可发送文本
nc localhost 9000
```

###简单的传文件
```
nc -l 9000 > test
#客户端 
cat test_file | nc localhost 9000
```

###连接超时
```
nc -l 9000 
#客户端10秒超时 
nc -w 10 localhost 9000
```

###指定网络类型
```
nc -4 -l 9000 
#客户端 
nc -4 localhost 9000 

nc -6 -l 9000 
#客户端 
nc -6 localhost 9000 

#验证可以使用
netstat | grep 9000
```

###禁止从标准输入读入数据
```
nc -l 9000 
#客户端 
nc -d localhost 9000
```

###不因为客户端的断开而关闭
```
nc -k -l 9000 
#客户端 
nc localhost 9000 
#中断客户端后可以重新连接
nc localhost 9000 
```

###使用udp协议
```
nc -4 -u -l 9000 
#客户端 
nc -4 -u localhost 9000 
#验证可以使用
netstat | grep 9000
```

###端口扫描器
```
nc –z example.com 20-100
```

###有效的传输文件
```
#服务端
nc –l 9090 | tar –xzf –
#客户端
tar –czf dir/ | nc server 9090
```

###把任何应用通过网络暴露出来
```
#通过8080端口把shell暴露出来
mkfifo backpipe
nc –l 8080 0<backpipe | /bin/bash > backpipe
#访问shell
nc example.com 8080
```
