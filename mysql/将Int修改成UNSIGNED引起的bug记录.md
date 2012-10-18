###本机的mysql版本是5.5:
	mysql> \s
	--------------
	mysql  Ver 14.14 Distrib 5.5.16, for osx10.6 (i386) using readline 5.1
###服务器的mysql版本是5.1:
	mysql> \s
	--------------
	mysql  Ver 14.14 Distrib 5.1.49, for debian-linux-gnu (x86_64) using readline 6.1

###数据表的结构:
	CREATE TABLE `example` (
	 `id` int(11) NOT NULL AUTO_INCREMENT,
	 `amount` int(11) unsigned DEFAULT NULL,
	 `planet_id` int(11) DEFAULT NULL,
	 `fleet_type` tinyint(4) DEFAULT NULL,
	 `fleet_category` tinyint(4) DEFAULT NULL,
	 `created_at` datetime DEFAULT NULL,
	 `updated_at` datetime DEFAULT NULL,
	 PRIMARY KEY (`id`),
	 KEY `index_fleets_on_planet_id` (`planet_id`),
	 KEY `index_fleets_on_fleet_type` (`fleet_type`),
	 KEY `index_fleets_on_fleet_category` (`fleet_category`)
	) ENGINE=InnoDB AUTO_INCREMENT=508467 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
字段amount初始值是0,更新出现不同的结果,本机5.5版本小于0的值被设置成0,而服务器5.1版本的被进行了二进制运算,造成大数产生。
```
sql => update example set amount=amount + -2 where id =1;
mysql> select * from example;
+----+------------+-----------+------------+----------------+---------------------+---------------------+
| id | amount     | planet_id | fleet_type | fleet_category | created_at          | updated_at          |
+----+------------+-----------+------------+----------------+---------------------+---------------------+
|  1 | 4294967295 |         1 |          1 |              1 | 2011-12-11 00:00:00 | 2011-12-11 00:00:00 |
+----+------------+-----------+------------+----------------+---------------------+---------------------+
1 row in set (0.00 sec)
```

可见2的32次方参与了运算造成4294967295大数的产生。必须进行符号转换。
```
sql => UPDATE `example` SET `amount` = CONVERT( amount +  (-100) ,SIGNED ) WHERE `id` = '1';
mysql> select * from example;
+----+--------+-----------+------------+----------------+---------------------+---------------------+
| id | amount | planet_id | fleet_type | fleet_category | created_at          | updated_at          |
+----+--------+-----------+------------+----------------+---------------------+---------------------+
|  1 |      0 |         1 |          1 |              1 | 2011-12-11 00:00:00 | 2011-12-11 00:00:00 |
+----+--------+-----------+------------+----------------+---------------------+---------------------+
1 row in set (0.00 sec)
```

进行符号转换后结果是0值.同样的进行累加。
```
UPDATE `example` SET `amount` = CONVERT( amount +  (500) ,SIGNED ) WHERE `id` = '1';
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> select * from example;
+----+--------+-----------+------------+----------------+---------------------+---------------------+
| id | amount | planet_id | fleet_type | fleet_category | created_at          | updated_at          |
+----+--------+-----------+------------+----------------+---------------------+---------------------+

|  1 |    600 |         1 |          1 |              1 | 2011-12-11 00:00:00 | 2011-12-11 00:00:00 |
+----+--------+-----------+------------+----------------+---------------------+---------------------+
1 row in set (0.00 sec)
```

[参考网址](http://hi.baidu.com/akshiak/blog/item/7c1e468bb3fd411fc9fc7a6f.html)
