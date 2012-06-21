###首先添加HTTP-SSL模块，检查openssl组件是否安装
```
whereis openssl
openssl: /usr/bin/openssl /usr/include/openssl /usr/share/man/man1/openssl.1ssl.gz
```
###已安装，非常good，重新编译NGINX
```
wget http://www.nginx.org/download/nginx-1.0.4.tar.gz
wget http://pushmodule.slact.net/downloads/nginx_http_push_module-0.692.tar.gz
tar zxvf nginx_http_push_module-0.692.tar.gz 
tar zxvf nginx-1.0.4.tar.gz 
cd nginx-1.0.4/
sudo ./configure --with-http_stub_status_module --with-http_ssl_module --add-module=../nginx_http_push_module-0.692/
sudo make && sudo make install
```
###使用openssl生成证书文件
```
sudo openssl genrsa -des3 -out server.key 1024
Generating RSA private key, 1024 bit long modulus
........................++++++
................++++++
e is 65537 (0x10001)
Enter pass phrase for server.key:
Verifying - Enter pass phrase for server.key:

sudo openssl req -new -key server.key -out server.csr
Enter pass phrase for server.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:CN
State or Province Name (full name) [Some-State]:Sichan
Locality Name (eg, city) []:Chengdu
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Xxx
Organizational Unit Name (eg, section) []:Xxx
Common Name (eg, YOUR name) []:Server Team
Email Address []:support@xxx.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:11504srv
An optional company name []:XXX Company

sudo cp server.key server.key.org
sudo openssl rsa -in server.key.org -out server.key
sudo openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
```
###证书生成好了，需要开启NGINX的SSL模块，做一个server和location
```
server {
        listen       443;
        server_name  ip地址;
        ssl          on;
        ssl_certificate /usr/local/nginx/conf/server.crt;
        ssl_certificate_key /usr/local/nginx/conf/server.key;
         
        location / {
                proxy_pass  http://127.0.0.1:9090;
                proxy_redirect     off;
                proxy_set_header   Host             $host;
                proxy_set_header   X-Real-IP        $remote_addr;
                proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
                client_max_body_size       10m;
                client_body_buffer_size    128k;
                proxy_connect_timeout      90;
                proxy_send_timeout         90;
                proxy_read_timeout         90;
                proxy_buffer_size          4k;
                proxy_buffers              4 32k;
                proxy_busy_buffers_size    64k;
                proxy_temp_file_write_size 64k;
        }
    }
```
###重新载入NGINX设置
```
sudo /usr/local/nginx/sbin/nginx -s reload
```
