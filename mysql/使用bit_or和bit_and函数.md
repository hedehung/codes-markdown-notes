###创建表
	mysql> CREATE TABLE `ta` (
	-> `id` smallint(5) unsigned NOT NULL default '0',
	-> KEY `id` (`id`)
	-> ) TYPE=MyISAM;
	Query OK, 0 rows affected (0.01 sec)

###插入测试数据
	mysql> INSERT INTO `ta` VALUES("1"),("2"),("3"),("4");
	Query OK, 8 rows affected (0.00 sec)
	Records: 4 Duplicates: 0 Warnings: 0

###bit_or函数
	mysql> SELECT BIT_OR(id) from ta;
	+------------+
	| BIT_OR(id) |
	+------------+
	| 7 |
	+------------+
	1 row in set (0.00 sec)

###分析bit_or
	....0001
	....0010
	....0011
	....0100
	OR..0000
	---------
	..0111

###bit_and函数
	mysql> SELECT BIT_AND(id) from ta;
	+-------------+
	| BIT_AND(id) |
	+-------------+
	| 0 |
	+-------------+
	1 row in set (0.00 sec)

###分析bit_and
	......0001
	......0010
	......0011
	......0100
	AND ..1111
	----------
	..0000

###BIT_AND(expr)
返回expr 中所有比特的bitwise AND 。计算执行的精确度为64 比特(BIGINT) 。
若找不到匹配的行，则这个函数返回18446744073709551615 。(这是无符号BIGINT 值，所有比特被设置为1）。

###BIT_OR(expr)
返回expr 中所有比特的bitwise OR。计算执行的精确度为64 比特(BIGINT) 。
若找不到匹配的行，则函数返回0 。

###BIT_XOR(expr)
返回expr 中所有比特的bitwise XOR。计算执行的精确度为64 比特(BIGINT) 。
若找不到匹配的行，则函数返回0 。
