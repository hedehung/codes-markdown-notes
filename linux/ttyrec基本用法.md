###下载安装
```
wget http://0xcc.net/ttyrec/ttyrec-1.0.8.tar.gz
tar zxvf ttyrec-1.0.8.tar.gz
cd ttyrec-1.0.8
sudo make
```

###开始shell记录
```
./ttyrec 
ls -la
exit
#回放 
./ttyplay ttyrecord
```

###回放参数
* "+" or "f" to speed up the playback twice  
* "-" or "s" to speed down the playback twice  
* "1" to change the playback to the normal speed  


###使用uuencode传输文件
```
ttyrec -u                 # Invoke ttyrec command with -u option.
ssh remotehost            # Log in to remotehost.
uuencode foo.zip foo.zip  # Transfer foo.zip with uuencode.
exit                      # Log out from remotehost.
ls foo.zip                # foo.zip is transfered!
#输出foo.zip   
```
