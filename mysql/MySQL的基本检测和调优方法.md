###查看当前的查询进程
```
sudo mysqladmin -uroot processlist
mysql> show processlist;
mysql> show full processlist;
```
###查看MySQL的统计状态
```
sudo mysqladmin -uroot status
sudo mysqladmin -uroot extended-status
mysql> show global status;
mysql> show global extended-status;
```
###查看MySQL的运行参数
```
sudo mysqladmin -uroot variables
mysql> show global variables;
```
###杀死某个查询线程
```
sudo mysqladmin -uroot kill 52
```
###查看数据库和表结构信息
```
mysql> show databases;
mysql> use civisland;
mysql> show tables;
mysql> desc users;
mysql> show index from users;
```
###查询语句的索引情况分析
```
explain SELECT `buildings`.* FROM `buildings` WHERE `buildings`.`type` = 'Line' AND town_id=2;
```
###显示InnoDB存储引擎的状态
```
mysql> show innodb status;
```
###测试sql语句的性能
```
mysql>set profiling=1; 
...some queries...
mysql> show profiles\G; 
mysql>show profile for query 1;
#cpu和block
mysql>show profile cpu, block io for query 1;
```
###数据表字段优化
```
select * from tablename procedure analyse();
```
###开启慢查询日志
```
log-slow-queries=/var/lib/mysql/slowquery.log (指定日志文件存放位置，可以为空，系统会给一个缺省的文件host_name-slow.log)
long_query_time=2 (记录超过的时间，默认为10s)
log-queries-not-using-indexes (log下来没有使用索引的query,可以根据情况决定是否开启)
log-long-format (如果设置了，所有没有使用索引的查询也将被记录)

mysqldumpslow -s c -t 20 slowquery.log
mysqldumpslow -s r -t 20 slowquery.log
```
###配置优化(Innodb模式)
```
＃超时控制
interactive_timeout = 10
wait_timeout = 10
innodb_lock_wait_timeout = 10
table_lock_wait_timeout = 10

innodb_buffer_pool_size = 2G
innodb_flush_method = O_DIRECT
innodb_flush_log_at_trx_commit = 2
```
###检测工具和脚本
```
mysqlslap #压力测试工具
MySQL super-smack #压力测试工具
mysqltuner #参数优化检测
```
###系统基本监测
```
top
iostat
dstat
mpstat
dstat
free
```
###高级监测
```
#高级监控
monit
nagios
cacti
```
