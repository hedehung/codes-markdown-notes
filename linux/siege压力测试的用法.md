###输出header信息 
```
siege -g www.google.com
```

###30秒内发送20个并发连接 
```
siege -c20 www.google.co.uk -b -t30s
```

###重现apache作负载测试 
```
cut -d ' ' -f7 /var/log/apache2/access.log > urls.txt
siege -c<并发个数> -b -f urls.txt 
```
