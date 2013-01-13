###环境要求
1. postfix
2. ruby

###安装postfix和ruby

```
sudo apt-get install postfix
sudo apt-get install ruby(或者使用rvm安装)
```

###修改postfix的main.cf配置文件

```
smtpd_use_tls = no禁用tls验证  
myhostname = mailserver.abc.com  
mydomain = mailserver.abc.com   
mydestination = abc.com   
mynetworks = mailserver.abc.com  
```

###重启postfix服务

```
sudo service postfix restarts
```

###修改主机名称

```
sudo vim /etc/hostname 将主机名修改为mailserver.abc.com
sudo hostname -F /etc/hostname 让其立即生效
```

###使用druby封装smtp邮件协议

```
#!/usr/bin/env ruby

require 'drb'
require 'drb/acl'
require 'base64'

$SAFE = 1

MS_IP = "服务器外网ip地址"
MS_PORT = 9000
MS_DOMAIN = "mailserver.abc.com"

class MailServer
	def send_mail_to_user(to, subject, body, from="support@abc.com")
		pipe = IO.popen("telnet #{MS_DOMAIN} smtp", "w")  
		pipe.puts "mail from: noreply@#{MS_DOMAIN}\n"  
		pipe.puts "rcpt to: #{to.gsub("\n", "")}\n"  
		pipe.puts "data\n"
		pipe.puts "From: #{from}\n"  
		pipe.puts "To: #{to.gsub("\n", "")}\n"  
		pipe.puts "Subject: =?UTF-8?B?#{subject.gsub("\n", "")}?=\n"  
     pipe.puts "Date: #{Time.new.to_s}\n" 
     pipe.puts "MIME-Version: 1.0\n"
		pipe.puts "Content-type: text/html; charset=utf8\n"
		pipe.puts "Content-Transfer-Encoding: base64\n"
		pipe.puts
		pipe.puts "#{body}\n"  
		pipe.puts ".\n" 
		pipe.puts "quit\n"
		pipe.close_write 
	end
end

ACL_CLIENT = %w{allow all}
DRb.install_acl(ACL.new(ACL_CLIENT))
DRb.start_service("druby://#{MS_IP}:#{MS_PORT}", MailServer.new)
DRb.thread.join
```

###使用god监控mail_server进程

```
God.watch do |w|
	w.interval = 30.seconds
	w.name = "mail_server"
	w.start = "ruby /home/ubuntu/drb_mail_service/mail_server.rb"
	w.keepalive
end
```

###启动和查看状态

```
god -c config.god
god status
```

###编写测试程序

```
#!/usr/bin/env ruby

require 'drb'
require 'base64'

MS_IP = "邮件服务器外网ip地址"
MS_PORT = "druby暴露的端口s"
ms = DRbObject.new_with_uri("druby://#{MS_IP}:#{MS_PORT}")

ms.send_mail_to_user("zhangsan@abc.coms", Base64.encode64("中文test"), Base64.encode64("中文test body goes here."))
```

###查看druby的连接

```
sudo lsof -i:9000
```

###添加spf、TXTs验证和主机A记录防止垃圾邮件

```
v=spf1 ipv4:外网ip地址 a mx ~all
```

###需要注意的地方
1. 必须使用base64编码，否则只能发送英文邮件。
2. 邮件头的Date是必须的，否则网易等会在邮件正文中插入message_id和发送时间，但是没有base64编码，邮件正文会显示乱码。
3. druby构建的RMI服务telnet必须以域名防止进入，否则rcpt to会发生relay access denied错误。
4. A记录是必须要添加的，邮件服务器会反向追踪主机地址。
5s. 可以通过查看邮件信头得到邮件接受服务器和spf的验证信息。
