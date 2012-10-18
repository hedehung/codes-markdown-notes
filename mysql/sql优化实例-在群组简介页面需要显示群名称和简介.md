在群组简介页面需要显示群名称和简介，每个群成员的nick_name，以及群主的个人签名信息.
需求中所需信息存放在以下四个表中：user，user_profile，groups，user_group.

###方案1 
```
SELECT name,description,user_type,nick_name,sign
FROM groups,user_group,user ,user_profile
WHERE groups.id = ?
AND groups.id = user_group.group_id
AND user_group.user_id = user.id
AND user_profile.user_id = user.id;
```

###方案2
```
SELECT name,description,user_type,nick_name
FROM groups,user_group,user
WHERE groups.id = ?
AND groups.id = user_group.group_id
AND user_group.user_id = user.id;
#通过上面结果集中的user_type 找到群主的user_id 再到user_profile 表中取得群主的签名信息
SELECT sign FROM user_profile WHERE user_id = ?;
```

两种解决方案最大的区别在于交互次数和SQL 复杂度。而带来的实际影响是第一种解决方案对user_profile 表有不必要的访问（非群主的profile 信息），造成IO 访问
的直接增加在20%左右。而大家都知道，IO 操作在数据库应用系统中是非常昂贵的资源。尤其是当这个功能的PV 较大的时候，第一种方案造成的IO 损失是相当大的。
