#mongodb副本集实践
准备运行1个主节点，2个从节点，从节点中其中是一个是仲裁节点(Arb)。

```
sudo mongod --replSet application --dbpath /data/node1/ --port 9927 --oplogSize 1024
sudo mongod --replSet application --dbpath /data/node2/ --port 9928 --oplogSize 1024
sudo mongod --replSet application --dbpath /data/arbiter/ --port 9929 --oplogSize 1024
```
其中application是副本集的名称，节点必须相同，--dbpath指定数据库储存路径，--port指定侦听端口，--oplogSize指定数据同步之前的缓存的空间大小，暂时指定1G。选择9927端口的实例为主节点，进入9927的shell:

```
mongo localhost:9927
```

初始化副本集需要配置表，申明配置表如下:

```
config = {_id: "application", members: []}
```
注意_id和副本集启动的共享名称一致。下面来逐步添加节点的数据信息：

```
config.members.push({_id: 0, host: "localhost:9927"})
config.members.push({_id: 1, host: "localhost:9928"})
config.members.push({_id: 2, host: "localhost:9929", arbiterOnly: true})
```
也可以使用rs.add和rs.addArb函数来实现同样的操作。然后需要用这个表作为参数初始化副本集，在9927端口的shell执行：

```
> rs.initiate(config)
{
	"info" : "Config now saved locally.  Should come online in about a minute.",
	"ok" : 1
}
```
返回ok为1表示初始化成功，三个节点互相检测通信，需要1分钟左右(反应够慢的 ^-^)，可以查看三个终端窗口的信息确认，完成通信后，在9927端口的shell回车执行命令确认配置：

```
> rs.isMaster()
{
	"setName" : "application",
	"ismaster" : true,
	"secondary" : false,
	"hosts" : [
		"localhost:9927",
		"localhost:9928"
	],
	"arbiters" : [
		"localhost:9929"
	],
	"primary" : "localhost:9927",
	"me" : "localhost:9927",
	"maxBsonObjectSize" : 16777216,
	"localTime" : ISODate("2013-01-26T13:34:03.378Z"),
	"ok" : 1
}
```
注意到9927端口的实例ismaster是true，secondary为false，hosts有2个实例，arbiter有1个元素，primary关键key表示了主节点，通信完成几次回车后可以看到9927的端口的实例shell的提示符已经改变，更改为application:PRIMARY，查看更详细的信息：

```
application:PRIMARY> rs.status()
{
	"set" : "application",
	"date" : ISODate("2013-01-26T13:34:35Z"),
	"myState" : 1,
	"members" : [
		{
			"_id" : 0,
			"name" : "localhost:9927",
			"health" : 1,
			"state" : 1,
			"stateStr" : "PRIMARY",
			"uptime" : 140,
			"optime" : Timestamp(1359207200000, 1),
			"optimeDate" : ISODate("2013-01-26T13:33:20Z"),
			"self" : true
		},
		{
			"_id" : 1,
			"name" : "localhost:9928",
			"health" : 1,
			"state" : 2,
			"stateStr" : "SECONDARY",
			"uptime" : 63,
			"optime" : Timestamp(1359207200000, 1),
			"optimeDate" : ISODate("2013-01-26T13:33:20Z"),
			"lastHeartbeat" : ISODate("2013-01-26T13:34:34Z"),
			"pingMs" : 0
		},
		{
			"_id" : 2,
			"name" : "localhost:9929",
			"health" : 1,
			"state" : 7,
			"stateStr" : "ARBITER",
			"uptime" : 63,
			"lastHeartbeat" : ISODate("2013-01-26T13:34:34Z"),
			"pingMs" : 0
		}
	],
	"ok" : 1
}
```
显示了每个节点的健康状况，名称，启动的时间，节点的类型等。查看当前副本集的配置表：

```
application:PRIMARY> rs.conf()
{
	"_id" : "application",
	"version" : 1,
	"members" : [
		{
			"_id" : 0,
			"host" : "localhost:9927"
		},
		{
			"_id" : 1,
			"host" : "localhost:9928"
		},
		{
			"_id" : 2,
			"host" : "localhost:9929",
			"arbiterOnly" : true
		}
	]
}
```
插入测试数据：

```
application:PRIMARY> db.users.insert({username: "zhangsan", age: 25})
```
进入9928从节点，执行查看集合：

```
application:SECONDARY> show collections
application:SECONDARY> show collections
Sat Jan 26 21:39:40 uncaught exception: error: { "$err" : "not master and slaveOk=false", "code" : 13435 }
```
发现shell抛出了异常，显示slaveOK为false，当前副本集需要明确从节点参数，执行函数：

```
application:SECONDARY> rs.slaveOk()
application:SECONDARY> show collections
system.indexes
users
```
查询测试数据：
```
application:SECONDARY> db.users.find()
{ "_id" : ObjectId("5103dbc8f556a05a96a28e69"), "username" : "zhangsan", "age" : 25 }
```
插入数据没有抛出异常，但是显示not master，表示当前从节点是只读的：

```
application:SECONDARY> db.users.insert({username: "lisi", age: 27})
not master
```

切换到9927主节点，使用系统空间库查询副本集信息：

```
application:PRIMARY> db.system.replset.findOne()
{
	"_id" : "application",
	"version" : 1,
	"members" : [
		{
			"_id" : 0,
			"host" : "localhost:9927"
		},
		{
			"_id" : 1,
			"host" : "localhost:9928"
		},
		{
			"_id" : 2,
			"host" : "localhost:9929",
			"arbiterOnly" : true
		}
	]
}
```

```
application:PRIMARY> db.getReplicationInfo()
{
	"logSizeMB" : 1024,
	"usedMB" : 0.01,
	"timeDiff" : 169,
	"timeDiffHours" : 0.05,
	"tFirst" : "Sat Jan 26 2013 21:33:20 GMT+0800 (CDT)",
	"tLast" : "Sat Jan 26 2013 21:36:09 GMT+0800 (CDT)",
	"now" : "Sat Jan 26 2013 21:48:07 GMT+0800 (CDT)"
}
```

进入9929端口，可以看到仲裁节点的提示符号：

```
mongo localhost:9929
application:ARBITER> 
```

执行故障转移测试，可以ctrl+c掉9927的主节点，观察终端信息提示，9927处于down状态，9928从节点自举为主节点，回车后发现shell提示符号已经更改为application:PRIMARY，再将9927上线，添加为从节点，再ctrl+c掉9928节点，经过少许时间，9927端口又恢复成主节点，再将9928上线，系统恢复到初始的副本集，仲裁节点的作用是协调leader选举，监测系统运行状态，提供节点互相通讯的数据信息。