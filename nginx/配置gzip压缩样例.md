###开启gzip样例
	gzip  on;
	gzip_min_length  600;
	gzip_buffers     4 8k;
	gzip_comp_level  6;  
	gzip_types text/plain text/css application/json application/x-javascript text/javascript;
