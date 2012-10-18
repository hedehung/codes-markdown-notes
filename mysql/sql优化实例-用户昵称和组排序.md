需求：取出某个group（假设id 为100）下的用户编号（id），用户昵称（nick_name）、用户性别（ sexuality ） 、用户签名（ sign ） 和用户生日（ birthday ） ， 并按照加入组的时间（user_group.gmt_create）来进行倒序排列，取出前20 个。

###方案1
```
SELECT id,nick_name
FROM user,user_group
WHERE user_group.group_id = 1
and user_group.user_id = user.id
limit 100,20;
```

###方案2
```
SELECT user.id,user.nick_name
FROM (
SELECT user_id
FROM user_group
WHERE user_group.group_id = 1
ORDER BY gmt_create desc
limit 100,20) t,user
WHERE t.user_id = user.id;
```

###方案3
```
mysql >explain
-> SELECT id,nick_name
-> FROM user,user_group
-> WHERE user_group.group_id = 1
-> and user_group.user_id = user.id
-> ORDER BY user_group.gmt_create desc
-> limit 100,20\G
*************************** 1. row ***************************
id: 1
select_type: SIMPLE
table: user_group
type: ref
possible_keys: user_group_uid_gid_ind,user_group_gid_ind
key: user_group_gid_ind
key_len: 4
ref: const
rows: 31156
Extra: Using where; Using filesort
*************************** 2. row ***************************
id: 1
select_type: SIMPLE
table: user
type: eq_ref
possible_keys: PRIMARY
key: PRIMARY
key_len: 4
ref: example.user_group.user_id
rows: 1
Extra:
sky@localhost : example 10:32:20> explain
-> SELECT user.id,user.nick_name
-> FROM (
-> SELECT user_id
-> FROM user_group
-> WHERE user_group.group_id = 1
-> ORDER BY gmt_create desc
-> limit 100,20) t,user
-> WHERE t.user_id = user.id\G
*************************** 1. row ***************************
id: 1
select_type: PRIMARY
table: <derived2>
type: ALL
possible_keys: NULL
key: NULL
key_len: NULL
ref: NULL
rows: 20
Extra:
*************************** 2. row ***************************
id: 1
select_type: PRIMARY
table: user
type: eq_ref
possible_keys: PRIMARY
key: PRIMARY
key_len: 4
ref: t.user_id
rows: 1
Extra:
*************************** 3. row ***************************
id: 2
select_type: DERIVED
table: user_group
type: ref
possible_keys: user_group_gid_ind
key: user_group_gid_ind
key_len: 4
ref: const
rows: 31156
Extra: Using filesort
```

解决方案一中的执行计划显示MySQL 在对两个参与Join 的表都利用到了索引，user_group 表利用了user_group_gid_ind 索引（ key: user_group_gid_ind ） ， user 表利用到了主键索引（ key RIMARY），在参与Join 前MySQL 通过Where 过滤后的结果集与user 表进行Join，最后通过排序取出Join 后结果的“limit 100,20”条结果返回。解决方案二的SQL 语句利用到了子查询，所以执行计划会稍微复杂一些，首先可以看到两个表都和解决方案1 一样都利用到了索引（所使用的索引也完全一样），执行计划显示该子查询以user_group 为驱动，也就是先通过user_group 进行过滤并马上进行这一论的结果集排序，也就取得了SQL 中的“limit 100,20”条结果，然后与user 表进行Join，得到相应的数据。这里可能有人会怀疑在自查询中从user_group表所取得与user 表参与Join 的记录条数并不是20 条，而是整个group_id=1 的所有结果。第一个方案在外层查询中的所有的20 条记录全部被返回。第一个解决方案中需要和user 表参与Join 的记录数MySQL 通过统计数据估算出来是31156，也就是通过user_group 表返回的所有满足group_id=1 的记录数（系统中的实际数据是20000）。而第二种解决方案的执行计划中，user 表参与Join 的数据就只有20条，两者相差很大，通过本节最初的分析，我们认为第二中解决方案应该明显优于第一种解决方案。
