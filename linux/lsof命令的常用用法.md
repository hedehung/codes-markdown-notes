###助记 
```
list open files
```

###查看某个端口被哪个进程开启
```
lsof -i:端口
```

###查看所属进程打开的所有的文件
```
lsof -u mysql
#可以使用正则表达式
#不包含root的信息
lsof -u ^root
#显示abc进程现在打开的文件
lsof -c abc 
```

###现实打开文件的所有进程
```
lsof  filename
```

###现实归属gid的进程打开的文件
```
lsof -g gid 
```

###现实目录下被进程打开的文件
```
lsof +d /DIR/
#递归搜索
lsof +D /DIR/
```

###查看所属root用户进程所打开的文件类型为txt的文件
```
#a表示满足条件
lsof -a -u root -d txt
```

###i表示条件,指定协议、端口、主机等的网络信息
```
lsof -i tcp@192.168.228.244
lsof -i:22
```

###按照打开文件数对进程排序
```
lsof -n|awk '{print $2}'|sort|uniq -c |sort -nr|more
ps -aef | grep 24042
```
