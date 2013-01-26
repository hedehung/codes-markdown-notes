#mongodb shell和mysql shell查询类比

###查看数据库
```
show dbs 
show databases;
```

###使用数据库
```
use mydb
use mydb;
```

###删除数据库
```
db.dropDatabase()
drop database db if exists db;
```

###列出表
```
show collections
show tables;
```

###清空表
```
db.users.remove()
truncate table users;
```

###删除表
```
db.users.drop()
drop table users if exists users;
```

###插入
```
db.users.insert({username: "zhangsan"})
insert into users(username) values('zhangsan');
```

###返回表结果
```
db.users.find()
select * from users;
db.users.findOne()
select * from users limit 1;
db.users.find({username: "zhangsan"})
select * from users where username='zhangsan';
db.users.find({age: {"gt": 20}})`
select * from users where age > 20;
db.users.find({}, {username: 1})
select username from users;
```

###更新
```
db.users.update({username: 'zhangsan'}, {"$set": {username: "lisi"}}, {multi: true})
update users set username='lisi' where username='zhangsan';
```

###删除
```
db.users.remove({username: "zhangsan"})
delete from users where username='zhangsan';
```

###IN操作
```
db.users.find({username: {"$in": ["zhangsan", "lisi"]}})
select * from users where username in ('zhangsan','lisi');
```

###范围查询
```
db.users.find({age: {"$gte": 20}, age: {"$lte": 30}})
select * from users where age >= 20 and age <= 30
db.users.find({age: {"$ne": "zhangsan"}})
select * from users where username != "zhangsan"
```

###排序
```
db.users.find({}).sort({age: -1, username: 1})
select * from users order by age desc, username asc
```

###分页
```
db.users.find({}).skip(10).limit(10)
select * from users limit 10,10
```

###聚合
```
db.users.distinct("username")
select distinct username from users;
```

###分组
```
map-reduce@#$@#$#@
select count(*) from users group by age;
```

###模糊匹配
```
db.users.find({username: /^zhangsan/})
select * from users where username like 'zhang%';
```

###自定义函数
```
db.users.find({"$where": "function(){return this.age > 20;}"})
create function @#$@#$%@#
```

###查询解释器
```
db.users.find({username: "zhangsan"}).explain()
explain select * from users where username='zhangsan';
```

###查看表索引
```
db.users.getIndexes()
show index from users;
```

###建立索引
```
db.users.ensureIndex({username: -1})
create index username on users(username);
db.users.ensureIndex({username: -1}, {unique: true})
create unique index username on users(username);
```
