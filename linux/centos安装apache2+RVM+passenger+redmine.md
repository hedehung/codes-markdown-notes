###安装apache2
```
yum install apache2 
```

###安装mysql
```
yum install mysql-server
```

###安装RVM
```
bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bash_profile
```

###列出知道的ruby包
```
rvm list known
```

###安装ruby-1.9.3-head包
```
rvm install ruby-1.9.3-head
```

###安装rails-3.2.6
```
rvm install rails -v3.2.6
```

###设置1.9.3环境为默认
```
rvm --default use 1.9.3
```

###安装passenger
```
wget http://rubyforge.org/frs/download.php/75548/passenger-3.0.11.tar.gz
tar -zxvf passenger-3.0.11.tar.gz
cp passenger-3.0.11 /usr/local 
cd /usr/local/passenger-3.0.11  
./bin/passenger-install-apache2-module
```

###修改apache2的httpd.conf文件加入passenger的动态库
```
/* 安装完passenger会有下面三行的提示 */
LoadModule passenger_module /usr/local/passenger-3.0.11/ext/apache2/mod_passenger.so  
PassengerRoot  /usr/local/passenger-3.0.11
PassengerRuby /usr/local/rvm/rubies/ruby-1.9.3-head/bin/ruby
```

###增加redmine的vhost配置
```
<VirtualHost *:80>
DocumentRoot /home/wwwroot/redmine/public_html/public
ServerName redmine.sweetsoft.cc
ServerAlias redmine.sweetsoft.cc
</VirtualHost>
<Directory /home/wwwroot/redmine/public_html/public>
    AllowOverride All
    Allow from all
    Options -MultiViews
</Directory>
```

###重启apache2
```
/etc/init.d/httpd restart
```

###下载redmine
```
cd /home/wwwroot/redmine/public_html/
svn co http://redmine.rubyforge.org/svn/branches/2.0-stable ./
```

###修改权限
```
chown -R www.www redmine/
cd public_html
chmod -R 755 files log tmp public/plugin_assets
```

###配置redmine数据库账号
```
cd /home/wwwroot/redmine/public_html/
cp config/database.yml.example config/database.yml
vim config/database.yml
```

###安装bundler
```
gem install bundler
```

###安装ImageMagick和RMagick
```
yum install -y glib glib2 zlib-devel libpng libjpeg libtiff ghostscript
yum install -y freetype-devel libjpeg-devel libpng-devel libtiff-devel libungif-devel
yum install ImageMagick
yum install ImageMagick-devel
```

###安装RMagick
```
wget http://rubyforge.org/frs/download.php/70066/RMagick-2.13.1.tar.gz
tar zxvf RMagick-2.13.1.tar.gz
cd RMagick-2.13.1
ruby setup.rb
```

###安装数据库
```
cd /home/wwwroot/redmine/public_html/ 
yum install sqlite-devel
yum install postgresql-devel
/* 编辑Gemfile文件加入gem "mysql" */
bundle install --without development test
/* 或者 */
bundle install --without development test postgresql sqlite
rake generate_secret_token
RAILS_ENV=production rake db:create
RAILS_ENV=production rake db:migrate
```

###载入默认数据
```
RAILS_ENV=production rake redmine:load_default_data
/* redmine会提示选择语言 */
```

###启动测试
```
ruby script/rails server webrick -e production
```

###访问使用默认的用户名和密码登录
```
/* cannot load such file -- phusion_passenger/analytics_logger */
gem install passenger

/* 清除svn标记 */
find . -type d -name ".svn"|xargs rm -rf

/* admin:admin */
login: admin
password: admin
```

###设置邮箱
[参考action_mailer for gmail](https://github.com/collectiveidea/action_mailer_optional_tls/tree/)
