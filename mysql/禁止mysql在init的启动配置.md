###步骤
	sudo vim /etc/init/mysql.conf
###改为	
	start on runlevel [!0123456]

也就是任何启动级别都不启动。
