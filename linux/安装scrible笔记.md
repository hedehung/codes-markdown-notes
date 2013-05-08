#安装依赖
```
apt-get install ruby-dev libevent-dev python-dev libevent-dev libboost-dev libboost-filesystem-dev collectd-dev bison flex automake autoconf ant libssl-dev git-core
```

#编译安装thrift
```
http://thrift.apache.org/download/
wget http://www.apache.org/dist/thrift/0.7.0/thrift-0.7.0.tar.gz

tar xvzf thrift-0.7.0.tar.gz
cd thrift-0.7.0
./configure
make
make install
```

#安装fb303
```
cd contrib/fb303
./bootstrap.sh
make
make install
```

#刷新动态库s
```
sudo vim /etc/ld.so.conf
#增加下面一行
/usr/local/lib
#刷新caches
sudo ldconfig
```

#安装scribe
```
git clone http://github.com/facebook/scribe.git
cd scribe
./bootstrap.sh
make
make install
```