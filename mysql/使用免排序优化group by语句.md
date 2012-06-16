###优化group by 语句
默认情况下，MySQL 排序所有GROUP BY col1，col2，....。查询的方法如同在查询中指定ORDER BY col1，col2，...。
如果显式包括一个包含相同的列的ORDER BY子句，MySQL 可以毫不减速地对它进行优化，尽管仍然进行排序。
如果查询包括GROUP BY 但你想要避免排序结果的消耗，你可以指定ORDER BY NULL禁止排序。
	例如：
	INSERT INTO foo SELECT a, COUNT(*) FROM bar GROUP BY a ORDER BY NULL;
