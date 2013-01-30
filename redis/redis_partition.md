#Redis Partition
#redis分区
[官方地址](http://redis.io/topics/partitioning)

Partitioning: how to split data among multiple Redis instances.

```
分区: 如何拆分数据分配到多个redis实例。
```

Partitioning is the process of splitting your data into multiple Redis instances, so that every instance will only contain a subset of your keys. The first part of this document will introduce you to the concept of partitioning, the second part will show you the alternatives for Redis partitioning.
Why partitioning is useful

```
分区是将数据拆分到多个redis实例中，每个实例只保存键值集合的一部分。次文档的第一部分将介绍分区的概念，第二部分说明如何使用redis分区。
```

Partitioning in Redis serves two main goals:

    It allows for much larger databases, using the sum of the memory of many computers. Without partitioning you are limited to the amount of memory a single computer can support.
    It allows to scale the computational power to multiple cores and multiple computers, and the network bandwidth to multiple computers and network adapters.
    
```
分区的主要目标:

分区针对大型的数据库，使用多个计算机的内存。没有分区，就会被单个计算机的内存所限制。
可以在多核和多台计算机之间扩展，并且适应不同的计算机带宽。
```    

##Partitioning basics

```
分区的基本概念
```

There are different partitioning criteria. Imagine we have four Redis instances R0, R1, R2, R3, and many keys representing users like user:1, user:2, ... and so forth, we can find different ways to select in which instance we store a given key. In other words there are different systems to map a given key to a given Redis server.

```
分区的条件有很多种。想象我们有4个redis服务器实例，分别表示为R0,R1,R2,R3，针对用户表有许多键值，比如user:1,user:2等等。我们可以使用不同的方法以便我们能根据键来找到它对应的值。换句话说，redis提供不同的子系统来实现键和实例的对应关系。
```

One of the simplest way to perform partitioning is called range partitioning, and is accomplished by mapping ranges of objects into specific Redis instances. For example I could say, users from ID 0 to ID 10000 will go into instance R0, while users form ID 10001 to ID 20000 will go into instance R1 and so forth.

```
一种最简单的分区方式就是范围分区，把某些范围的对象固定的映射到redis服务器实例。比如说，我可以把用户表中ID从0到10000的键映射到R0上，ID从10001到20000的键映射到R1上等等。
```

This systems works and is actually used in practice, however it has the disadvantage that there is to take a table mapping ranges to instances. This table needs to be managed and we need a table for every kind of object we have. Usually with Redis it is not a good idea.

```
这种工作方式在实践中被大量的使用，尽管有所缺点。这种映射方式要求我们知道每种需要被管理的对象。对于redis来说，这种方式其实不是一个好主意。
```

An alternative to to range partitioning is hash partitioning. This scheme works with any key, no need for a key in the form object_name:<id> as is as simple as this:

```
一个替代范围分区的方法是散列分区。这种方法适用于任意键，不需要对象提供id，非常的简单：
```

    Take the key name and use an hash function to turn it into a number. For instance I could use the crc32 hash function. So if the key is foobar I do crc32(foobar) that will output something like 93024922.
    I use a modulo operation with this number in order to turn it into a number between 0 and 3, so that I can map this number to one of the four Redis instances I've. So 93024922 modulo 4 equals 2, so I know my key foobar should be stored into the R2 instance. Note: the modulo operation is just the rest of the division, usually it is implemented by the % operator in many programming languages.
    
```
将对象的键值使用哈西函数变换得到一个数值。例如我使用CRC32算法，加入关键键值是foorbar，那么CRC32(foobar)将会得到93024922。
我再使用取模的函数将这个值转换成0到3之间的数值，这个数字可以看成是映射到redis实例的序号，所以93024922模上4等于2，这样我知道foobar这个键值被存储到R2实例中。
```

There are many other ways to perform partitioning, but with this two examples you should get the idea. One advanced form of hash partitioning is called consistent hashing and is implemented by a few Redis clients and proxies.

```
通过这俩个例子，你应该猜到还有很多其他的方法来进行分区。一种先进的通过客户端和代理的方法实现的哈西分区的方式称为一致性哈西散列分区。
```

##Different implementations of partitioning

```
不同的分区实现
```

Partitioning can be responsibility of different parts of a software stack.

```
分区体现再软件的各个部分。
```

    Client side partitioning means that the clients directly select the right node where to write or read a given key. Many Redis clients implement client side partitioning.
   
```
客户端分区意味着客户端根据键直接选择合适的节点进行读写操作。许多redis的客户端都使用这种方式实现分区。
```
    
    Proxy assisted partitioning means that our clients send requests to a proxy that is able to speak the Redis protocol, instead of sending requests directly to the right Redis instance. The proxy will make sure to forward our request to the right Redis instance accordingly to the configured partitioning schema, and will send the replies back to the client. The Redis and Memcached proxy Twemproxy implements proxy assisted partitioning.
    
```
代理分区意味着客户端发送请求到一个能处理redis协议的中间代理，而不是直接发送请求给redis服务器。中间代理将决定把我们的请求派发到分区结构上，并且负责回传处理结果给客户端。redis和memached代理Twemproxy就是这样的中间代理。
```

    Query routing means that you can send your query to a random instance, and the instance will make sure to forward your query to the right node. Redis Cluster implements an hybrid form of query routing, with the help of the client (the request is not directly forwarded from a Redis instance to another, but the client gets redirected to the right node).
    
```
查询路由意味着你可以发送请求到随机的redis实例，这个实例将转发你的请求给合适的节点进行处理。redis集群实现了混合形式的查询路由(请求不是直接从redis实例转发到另一个，但是客户端被重定向到合适的节点)。
```

##Disadvantages of partitioning

```
分区的缺点
```

Some features of Redis don't play very well with partitioning:

```
redis分区不能很好处理的情况是:
```

    Operations involving multiple keys are usually not supported. For instance you can't perform the intersection between two sets if they are stored in keys that are mapped to different Redis instances (actually there are ways to do this, but not directly).
    
```
操作涉及到多个键值是不被支持的。例如你无法操作俩个交叉集合，因为他们被映射到了不同的redis实例(实际上有办法做到，但是不直接)。
```
    
    Redis transactions involving multiple keys can not be used.
    
```
涉及到事务的多个键不能使用。
```

    The partitioning granuliary is the key, so it is not possible to shard a dataset with a single huge key like a very big sorted set.

```
使用类似于一个大的排序集合将单一的数据集进行分片是不太可能的，因为分区的关键就是键。
```

    When partitioning is used, data handling is more complex, for instance you have to handle multiple RDB / AOF files, and to make a backup of your data you need to aggregate the persistence files from multiple instances and hosts.
    
```
如果使用分区，数据的处理会变得复杂，你不得不对付多个redis数据库和AOF文件，不得在多个实例和主机之间持久化你的数据。
```

    Adding and removing capacity can be complex. For instance Redis Cluster plans to support mostly transparent rebalancing of data with the ability to add and remove nodes at runtime, but other systems like client side partitioning and proxies don't support this feature. However a technique called Presharding helps in this regard.
    
```
添加和删除节点也会变得复杂。比如redis集群计划支持透明的运行时添加和删除节点，但是像客户端分区或者代理分区的特性就不会再被支持。然而一种称为Presharding(预分片)的技术可以在这方面提供帮助。
```

##Data store or cache?

```
数据持久化还是缓存?
```

Partitioning when using Redis ad a data store or cache is conceptually the same, however there is a huge difference. While when Redis is used as a data store you need to be sure that a given key always maps to the same instance, when Redis is used as a cache if a given node is unavailable it is not a big problem if we start using a different node, altering the key-instance map as we wish to improve the availability of the system (that is, the ability of the system to reply to our queries).

```
使用redis存储数据或者缓存数据在概念上是相同的，但是这两者有巨大的插逼啊。当redis被持久化数据存储服务器的时候意味着对于相同的键值必须被映射到相同的实例上面，但是如果把redis当作数据缓存器，当我们使用不同的节点的时候，找不到对应键值的对象不是什么大问题(缓存就是随时准备好牺牲自己)，改变键值和实例映射逻辑可以提供系统的可用性(也就是系统哦你看过处理查询请求的能力)。
```

Consistent hashing implementations are often able to switch to other nodes if the preferred node for a given key is not available. Similarly if you add a new node, part of the new keys will start to be stored on the new node.

```
一致性哈西的实现在给定的键值不可用的情况下常常能够切换到其他的节点。同样的，你添加一个新的节点，部分新的键值开始存储到新添加的节点上面。
```

The main concept here is the following:

```
主要的概念如下:
```

    If Redis is used as a cache scaling up and down using consistent hashing is easy.
    
```
如果redis被作为缓存服务器那么使用哈西是相当蓉易的。
```

    If Redis is used as a store, we need to take the map between keys and nodes fixed, and a fixed number of nodes. Otherwise we need a system that is able to rebalance keys between nodes when we add or remove nodes, and currently only Redis Cluster is able to do this, but Redis Cluster is not production ready.
    
```
若果redis被作为数据持久化服务器，我们需要提供节点和键值的固定映射，还有一组固定的redis实例节点。否则我们系统可以允许我们增加或者删除键值和节点，目前，只有redis集群可以做到这点，但是redis集群还没有发展成正式版本。
```

##Presharding

```
预分片
```

We learned that a problem with partitioning is that, unless we are using Redis as a cache, to add and remove nodes can be tricky, and it is much simpler to use a fixed keys-instances map.

```
从分区的概念中，我们明白了一个问题。除非把redis当作缓存服务器使用，否则添加和删除redis节点会显得非常棘手，相反使用固定的键值和实例映射倒是非常的简单。
```

However the data storage needs may vary over the time. Today I can live with 10 Redis nodes (instances), but tomorrow I may need 50 nodes.

```
然后数据存储要求可能会变化，今天我可以忍受10个节点，但是明天数据量增大我可能需要50个节点。
```

Since Redis is extremely small footprint and lightweight (a spare instance uses 1 MB of memory), a simple approach to this problem is to start with a lot of instances since the start. Even if you start with just one server, you can decide to live in a distributed world since your first day, and run multiple Redis instances in your single server, using partitioning.


```
因为redis足够轻量和小巧(一个备用实例使用1M的内存)，解决这个问题的简单方法就是一开始就使用大量的实例节点。即使你开始是有一个服务器，你可以决定换成分布式的结构，因为可以在单个服务器上通过分区分方式来运行多个redis节点。
```

And you can select this number of instances to be quite big since the start. For example, 32 or 64 instances could do the trick for most users, and will provide enough room for growth.

```
你可以选择的实例个数可以相当的打。例如，对大多数用户来说32个或者64个实例将提供足够的增长空间。
```

In this way as your data storage needs increase and you need more Redis servers, what to do is to simply move instances from one server to another. Once you add the first additional server, you will need to move half of the Redis instances from the first server to the second, and so forth.

```
通过这样的方法来满足数据存储需求的增加，你需要更多的redis服务器，需要做的工作只是简单的把这个服务器的节点移动到另外的服务器上面。一旦你添加了额外的服务器，你可以将一半的redis的实例移动到第二个等等。
```

Using Redis replication you will likely be able to do the move with minimal or no downtime for your users:

```
你可能会使用redis主从复制来减少停机时间。
```

    Start empty instances in your new server.
    Move data configuring these new instances as slaves for your source instances.
    Stop your clients.
    Update the configuration of the moved instances with the new server IP address.
    Send the SLAVEOF NO ONE command to the slaves in the new server.
    Restart your clients with the new updated configuration.
    Finally shut down the no longer used instances in the old server.
    
```
在新的服务器上开启新的空实例。
将节点的数据配置移动到从服务器上。
停止客户端工作。
在新的服务器上更新移动过来的节点配置。
发送SLAVEOF NO ONE命令到新服务器的从节点。
使用新的配置重启客户端。
最后永久关闭不再托管节点的老服务器。
``` 

##Implementations of Redis partitioning

```
redis的分区实现
```

So far we covered Redis partitioning in theory, but what about practice? What system should you use?

```
目前为止我们讲完了分区理论，但是如何实战？应该使用什么系统？ 
```

##Redis Cluster

```
redis集群
```

Unfortunately Redis Cluster is currently not production ready, however you can get more information about it reading the specification or checking the partial implementation in the unstable branch of the Redis GitHub repositoriy.

```
不幸的是redis集群的正式版本还没有准备好，但是你可以在github上面的不稳定的分支上阅读它的规范和部分实现。
```

Once Redis Cluster will be available, and if a Redis Cluster complaint client is available for your language, Redis Cluster will be the de facto standard for Redis partitioning.

```
一旦redis集群正式版本发布，并且提供的客户端语言接口可用，那么这种方式将成为标准的redis分区方式。
```

Redis Cluster is a mix between query routing and client side partitioning.

```
redis集群是一个查村路由和客户端分区的混合体。
```

##Twemproxy

Twemproxy is a proxy developed at Twitter for the Memcached ASCII and the Redis protocol. It is single threaded, it is written in C, and is extremely fast. It is open source software released under the terms of the Apache 2.0 license.

```
Twemproxy是一个由Twitter开发的适合memached和redis协议的代理。它是单线程工作，使用C语言实现的，非常的快速。并且是Apache 2.0版权申明下的开源软件。
```

Twemproxy supports automatic partitioning among multiple Redis instances, with optional node ejection if a node is not available (this will change the keys-instances map, so you should use this feature only if you are using Redis as a cache).

```
Twemproxy支持自动在多个redis节点分区，如果某个节点不可用，将会被自动屏蔽(这将改变键值和节点映射表，所以如果你把redis当作缓存服务器使用你应该使用这个功能)。
```

It is not a single point of failure since you can start multiple proxies and instruct your clients to connect to the first that accepts the connection.

```
你可以启动多个代理，让你的客户端得到可以可用的连接，这样不会发生单点故障。
```

Basically Twemproxy is an intermediate layer between clients and Redis instances, that will reliably handle partitioning for us with minimal additional complexities. Currently it is the suggested way to handle partitioning with Redis.

```
Twemproxy基本上是redis和客户端的一个过渡层，通过简化使用复杂性让我们使用可靠的分区。目前这也是使用redis分区的推荐方案。
```

You can read more about Twemproxy in this antirez blog post.

```
你可以在antirez的博客发现有关Twemproxy的更多知识。
```

##Clients supporting consistent hashing

```
客户端一致性哈西实现
```

An alternative to Twemproxy is to use a client that implements client side partitioning via consistent hashing or other similar algorithms. There are multiple Redis clients with support for consistent hashing, notably Redis-rb and Predis.

```
替代Twemproxy的一种方案是使用客户端一致性哈西或者其他类似的算法。有需要redis客户端支持一致性哈西，比如Redis-rb和Predis。
```

Please check the full list of Redis clients to check if there is a mature client with consistent hashing implementation for your language.

```
请检查列表以确定是否有成熟的一致性哈西实现的，并且适合于你的编程语言的客户端。
```
