###查看网页源代码
```
curl -o [文件名] www.sina.com
```

###自动跳转
```
curl -L www.sina.com
```

###显示response的头信息
```
curl -i www.sina.com
```

###显示通讯过程,包括端口连接和request头信息
```
curl -v www.sina.com
或
curl --trace output.txt www.sina.com 
或 
curl --trace-ascii output.txt www.sina.com
```

###发送表单
```
curl example.com/form.cgi?data=xxx 
#post方法
curl --data "data=xxx" example.com/form.cgi 
#支持表单编码
curl --data-urlencode "date=April 1" example.com/form.cgi
```

###文件上传 
```
<form method="POST" enctype='multipart/form-data' action="upload.cgi">
　　<input type=file name=upload>
　　<input type=submit name=press value="OK">
</form>
curl --form upload=@localfilename --form press=OK example.com/upload.cgi
```

###提供referer字段
```
curl --referer http://www.example.com http://www.example.com
```

###模拟user-agent
```
curl --user-agent "[User Agent]" [URL] 
```

###发送cookies
```
curl --cookie "name=xxx" www.example.com
```

###增加头信息
```
curl --header "key: value" http://example.com 
```

###basic认证
```
curl --user name:password example.com
```
