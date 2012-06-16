###SELECT SQL_BUFFER_RESULTS
强制MySQL 生成一个临时结果集。只要所有临时结果集生成后，所有表上的锁定均被释放。这能在遇到表锁定问题时或要花很长时间将结果传给客户端时有所帮助。
当处理耗费时间才能处理的大结果集时，可以考虑使用SQL_BUFFER_RESULT 提示字。这样可以告诉MySQL 将结果集保存在一个临时表中，这样可以尽早的释放各种锁。

###USE INDEX
在你查询语句中表名的后面，添加USE INDEX 来提供你希望MySQ 去参考的索引列表，就可以让MySQL 不再考虑其他可用的索引。
		SELECT * FROM mytable USE INDEX (mod_time, name) ...

###IGNORE INDEX
如果你只是单纯的想让MySQL 忽略一个或者多个索引，可以使用IGNORE INDEX 作为Hint。
		SELECT * FROM mytale IGNORE INDEX (priority) ...

###FORCE INDEX
为强制MySQL 使用一个特定的索引，可在查询中使用FORCE INDEX 作为Hint。
		SELECT * FROM mytable FORCE INDEX (mod_time) ...
