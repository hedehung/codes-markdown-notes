###last
基本上都用这个Flag,相当于Apache里的[L]标记,表示完成rewrite,不再匹配后面的规则.

###break 
中止Rewirte,不再继续匹配. 

###redirect 
返回临时重定向的HTTP状态302.

###permanent 
返回永久重定向的HTTP状态301 ※原有的url支持正则重写的url不支持正.
