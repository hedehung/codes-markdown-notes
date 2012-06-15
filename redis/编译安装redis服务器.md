###步骤
	wget http://redis.googlecode.com/files/redis-2.4.11.tar.gz
	tar zxvf redis-2.4.11.tar.gz
	cd redis-2.4.11
	sudo make && sudo make install
	sudo cp src/redis-server src/redis-cli /usr/bin
	sudo mkdir -p /etc/redis/
	sudo cp redis.conf /etc/redis/
