###shell的办法
```
#!/bin/sh
cp /var/www/apps/galaxy/current/log/production.log /var/www/apps/galaxy/current/log/production-`date +%Y-%m-%d`.log
gzip /var/www/apps/galaxy/current/log/production-`date +%Y-%m-%d`.log
echo -n > /var/www/apps/galaxy/current/log/production.log
```

###rails的办法(实际使用好像切分了很多小文件，request同步访问造成)
#####每天切分一次日志文件
```
config.logger = Logger.new("#{Rails.root}/log/#{Rails.env}#{Date.today.to_s}.log", "daily")
```
####按日志文件大小切分,每50M切分一次（即每50M时轮换一次）
```
config.logger = Logger.new("#{Rails.root}/log/#{Rails.env}1.log", 2, 51200000)
```

###logrotate的办法
```
sudo apt-get install logrotate
sudo vim /etc/logrotate.conf

/path_to_app/log/production.log 
{
	daily #按日阶段
	missingok
	rotate 7 #保留7天
	compress #压缩
	delaycompress #不压缩前一个(previous)截断的文件（需要与compress一起用）
	dateext #增加日期作为后缀，不然会是一串无意义的数字
	copytruncate #清空原有文件，而不是创建一个新文件
} 

sudo /usr/sbin/logrotate /etc/logrotate.conf
```
