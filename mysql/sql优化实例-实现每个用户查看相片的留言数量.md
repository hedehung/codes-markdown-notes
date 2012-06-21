需求: 实现每个用户查看各自相册列表（假设每个列表显示10 张相片）的时候，能够在相片名称后面显示该相片的留言数量。

###方案1
```
SELECT id,subject,url FROM photo WHERE user_id = ? limit 10;
#遍历循环
SELECT COUNT(*) FROM photo_comment WHERE photh_id = ?;
```

###方案2
```
SELECT id FROM photo WHERE user_id = ? limit 10;
SELECT photo_id,count(*) FROM
photo_comment WHERE photo_id in (?) GROUP BY photo_id;
```

1. 执行sql语句数量： 第一种解决方案为11（1+10=11）条SQL 语句，第二种解决方案为2 条SQL 语句（1+1）.
2. 序与数据库交互：第一种为11 次，第二种为2.
3. 数据库的IO 操作:第一种最少11 次IO，第二种小于等于11次IO，而且只有当数据非常之离散的情况下才会需要11 次.
4. 数据库处理的查询复杂度:第一种为两类很简单的查询，第二种有一条SQL 语句有GROUP BY 操作，比第一种解决方案增加了了排序分组操作.
5. 应用程序结果集处理:第一种11 次结果集的处理，第二中2 次结果集的处理，但是第二种解决方案中第二词结果处理数量是第一次的10 倍.
6. 应用程序数据处理:第二种比第一种多了一个拼装photo_id 的过程.

从整体资源消耗来看，第二中方案会远远优于第一种解决方案.
