###针对Myisam 和Innodb 存储引擎都计数
1. Com_select 执行select 操作的次数，一次查询只累加1；
2. Com_insert 执行insert 操作的次数，对于批量插入的insert 操作，只累加一次；
3. Com_update 执行update 操作的次数；
4. Com_delete 执行delete 操作的次数；

###针对Innodb 存储引擎计数的
1. Innodb_rows_read select 查询返回的行数；
2. Innodb_rows_inserted 执行Insert 操作插入的行数；
3. Innodb_rows_updated 执行update 操作更新的行数；
4. Innodb_rows_deleted 执行delete 操作删除的行数；

###Com_commit和Com_rollback
对于事务型的应用，通过Com_commit 和Com_rollback 可以了解事务提交和回滚的情况，对于回滚操作非常频繁的数据库，可能意味着应用编写存在问题。

###Handler_read_key和Handler_read_rnd_next
如果索引正在工作，Handler_read_key 的值将很高，这个值代表了一个行被索引值读的次数，很低的值表明增加索引得到的性能改善不高，因为索引并不经常使用。
Handler_read_rnd_next 的值高则意味着查询运行低效，并且应该建立索引补救。这个值的含义是在数据文件中读下一行的请求数。如果你正进行大量的表扫描，该值较高。通常说明表索引不正确或写入的查询没有利用索引。

###table_locks_waited和table_locks_immediate
cks_waited 和table_locks_immediate 状态变量来分析系统上的表锁定争夺。
```
mysql> show status like 'Table%';
+----------------------------+----------+
| Variable_name | Value |
+----------------------------+----------+
| Table_locks_immediate | 105 |
| Table_locks_waited | 3 |
+----------------------------+----------+
2 rows in set (0.00 sec)
```

###查Innodb_row_lock
检查Innodb_row_lock 状态变量来分析系统上的行锁的争夺情况。
```
mysql> show status like 'innodb_row_lock%';
+----------------------------------------+----------+
| Variable_name | Value |
+----------------------------------------+----------+
| Innodb_row_lock_current_waits | 0 |
| Innodb_row_lock_time | 2001 |
| Innodb_row_lock_time_avg | 667 |
| Innodb_row_lock_time_max | 845 |
| Innodb_row_lock_waits | 3 |
+----------------------------------------+----------+
5 rows in set (0.00 sec)
```
