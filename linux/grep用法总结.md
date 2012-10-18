###查找使用了$redis变量的rb文件
```
grep -rinw -C 1 "\$redis" *\.rb
```
###显示匹配'username'行后面10行的内容
```
grep -A 10 'username' log/production.log
```
###显示前面5行和后面10行的内容
```
grep -B 5 -A 10 'username' log/production.log
```
###显示前后5行的内容
```
grep -C 5 'username' log/production.log
```
###查找用户名不是could的登录记录
```
grep '\("username"=>"could"\).*\("action"=>"create"\).*\("controller"=>"sessions"\)' production.log
```
###查找用户名是could或 sss1的登录记录
```
grep '[^\("username"=>"could"\)].*\("action"=>"create"\).*\("controller"=>"sessions"\)' production.log
```
###查找用户名是could或 sss1的登录记录
```
grep '\("username"=>"could\|sss1"\).*\("action"=>"create"\).*\("controller"=>"sessions"\)' production.log
```
###杀死含gatway的进程
```
kill -KILL $(ps -ef| grep 'gateway'| awk '{print $2}')
```
