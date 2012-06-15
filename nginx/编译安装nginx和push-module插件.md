###步骤
	wget http://nginx.org/download/nginx-1.2.0.tar.gz
	wget http://pushmodule.slact.net/downloads/nginx_http_push_module-0.692.tar.gz
	tar zxvf nginx_http_push_module-0.692.tar.gz
	tar zxvf nginx-1.2.0.tar.gz
	cd nginx-1.2.0/
	sudo ./configure --with-http_stub_status_module --with-http_ssl_module --add-module=../nginx_http_push_module-0.692/
	sudo make && sudo make install
