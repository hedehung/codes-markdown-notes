###find 常用的参数有 
* [size] 根据文件大小查找 
* [atime] 根据访问时间查找
* [ctime] 根据修改时间来查找
* [type] 根据文件类型来查找
* [name] 文件名样式
* [regex] 文件名的正则表达式   

###按照属性查找实例
```
find ./ -type f  -name grep.txt # 查找文件名是grep.txt的普通文件
find ./ -type f -regex ".*.[txt|c]" # 查找文件名以txt和c的普通文件 
find ./ -size +10M 查找文件大于10M的文件
find ./ -atime -1 查找一天内访问过的文件
find ./ -mtime -1 查找一天内读写多的文件
```

###name 和 regex 参数的区别在于
* name只支持一些基本的正则表达式元字符如 * . _ 等。而regex支持完整的正则表达式
* name是匹配文件的名称，而regex 则是匹配文件的整个绝对路径
```
find ./ -name 'find.*'
find ./ -regex 'find.*' #错误找不到
```

###size 可以跟的单位一般有 c (byte),k (kb),w(word),M,G,+ 和 - 表示 在区间之外和之类。
```
find ./ -atime -1  #一天内访问的文件
find ./ -atime +1 #大于一天的访问了的文件
```

###实例
```
find /home/ubuntu/SERVERS_DB_BACKUP/ -type f -mtime +7 -exec rm {} \;
```
