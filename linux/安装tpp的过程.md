###下载tpp和ncurses-ruby
```
wget http://www.ngolde.de/download/tpp-1.3.1.tar.gz
wget http://prdownload.berlios.de/ncurses-ruby/ncurses-ruby-1.3.1.tar.bz2
```

###tpp的README前置条件 
* ruby 1.8 <http://www.ruby-lang.org/>
* a recent version of ncurses
* ncurses-ruby <http://ncurses-ruby.berlios.de/> 
```

###切换到1.8.7环境 
```
rvm use system
```

###解压后进入tpp
```
tpp-1.3.1  ruby tpp.rb examples/test.tpp 
There is no Ncurses-Ruby package installed which is needed by TPP.
You can download it on: http://ncurses-ruby.berlios.de/
```

###进入ncurses-ruby 
```
cd ncurses-ruby-1.3.1
#根据README安装 
sudo ruby extconf.rb 
sudo make 
#出现error缺少ncurses静态库
```

###下载安装ncurses-5.9库 
```
wget http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz 
tar zxvf ncurses-5.9.tar.gz 
cd ncurses-5.9
sudo ./configure --prefix=/usr --with-shared --without-debug --enable-widec 
sudo make && sudo make install 
```

###重新安装ncurses-ruby 
```
cd ncurses-ruby-1.3.1 
sudo ruby extconf.rb 
sudo make && sudo make install 
```

###安装tpp程序
```
cd tpp-1.3.1 
sudo make install 
#输出
mkdir -p /usr/local/share/doc/tpp 
install -m644 DESIGN CHANGES COPYING README THANKS /usr/local/share/doc/tpp 
install -m644 doc/tpp.1 /usr/local/share/man/man1
install tpp.rb /usr/local/bin/tpp     
mkdir -p /usr/local/share/doc/tpp/contrib
mkdir -p /usr/local/share/doc/tpp/examples
install -m644 examples/* /usr/local/share/doc/tpp/examples/
install -m644 contrib/* /usr/local/share/doc/tpp/contrib/
```

###控制
```
space bar .............................. display next entry within page
space bar, cursor-down, cursor-right ... display next page
b, cursor-up, cursor-left .............. display previous page
q, Q ................................... quit tpp
j, J ................................... jump directly to page
l, L ................................... reload current file
s, S ................................... jump to the start page
e, E ................................... jump to the last page
c, C ................................... start command line
?, h ................................... show help screen
```
