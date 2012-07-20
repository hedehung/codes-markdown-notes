###安装postfix
```
sudo apt-get install postfix
```

###配置postfix
```
/* 重要参数 */
myhostname = mailserver.abc.com
/* 重要参数 */
mydomain = mailserver.abc.com
mydestination = abc.com
/* 重要参数 */
mynetworks = mailserver.abc.com
mailbox_size_limit = 0
header_checks = regexp:/etc/postfix/header_checks
```

###编辑/etc/postfix/header_checks
```
/^Organization:.*/ IGNORE
/^X-mailer:.*/ IGNORE
```

###设定主机名
```
sudo hostname mailserver.abc.com
/* 永久修改 */
sudo vim /etc/hosts
```

###重新启动postfix服务
```
sudo service postfix restart
```

###telnet测试
```
telnet 域名 smtp 
>mail from: xxx
>rcpt to: xxx
>data
>From:xxx
>To:xxx 
>Subject:xxx 
>Content-type:xxx 
>Content-Transfer-Encoding:xxx 
>
>内容
>.
>quit 
>
```

###编写drb邮件服务接口
```ruby
#!/usr/bin/env ruby

require 'drb'
require 'drb/acl'
require 'base64'

$SAFE = 1

class MailServer
	def send_mail_to_user(to, subject, body)
		pipe = IO.popen("telnet mailserver.abc.com smtp", "w")  
		pipe.puts "mail from: noreply@mailserver.abc.com\n"  
		pipe.puts "rcpt to: #{to.gsub("\n", "")}\n"  
		pipe.puts "data\n"
		pipe.puts "From: support@abc.com\n"  
		pipe.puts "To: #{to.gsub("\n", "")}\n"  
		pipe.puts "Subject: =?UTF-8?B?#{subject.gsub("\n", "")}?=\n"  
		pipe.puts "Content-type: text/html; charset=utf8\n"
		pipe.puts "Content-Transfer-Encoding: base64\r\n"
		pipe.puts
		pipe.puts "#{body}\n"  
		pipe.puts ".\n" 
		pipe.puts "quit\n"
		pipe.close_write 
	end
end

ACL_CLIENT = %w{allow all}
DRb.install_acl(ACL.new(ACL_CLIENT))
DRb.start_service("druby://本地ip:3000", MailServer.new)
DRb.thread.join
```

###添加A记录和SPF验证
```
v=spf1 ipv4:邮件服务器ip a mx ~all
```
