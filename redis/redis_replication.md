#Redis Replication
#Redis主从复制

Redis replication is a very simple to use and configure master-slave replication that allows slave Redis servers to be exact copies of master servers. The following are some very important facts about Redis replication:

```
Redis主从复制是非常简单易用的，主从复制允许从服务器精确的拷贝主服务器的数据。下面列出Redis主从复制结构非常重要的特性：
```

###A master can have multiple slaves.
###一个主服务器可配置多个从服务器.

Slaves are able to accept other slaves connections. Aside from connecting a number of slaves to the same master, slaves can also be connected to other slaves in a graph-like structure.

Redis replication is non-blocking on the master side, this means that the master will continue to serve queries when one or more slaves perform the first synchronization.


```
从服务器还可以接受其他从服务器的连接请求。除了连接大量的从服务器到相同的主服务器外，从服务器还能连接到其他的从服务器。主服务器是非阻塞的，这意味着主服务器可以接受从多个服务器的同步查询请求。
```

Replication is non blocking on the slave side: while the slave is performing the first synchronization it can reply to queries using the old version of the data set, assuming you configured Redis to do so in redis.conf. Otherwise you can configure Redis slaves to send clients an error if the link with the master is down. However there is a moment where the old dataset must be deleted and the new one must be loaded by the slave where it will block incoming connections.

```
从服务器也是非阻塞的：当从服务器在同步主服务器的数据尚未完成的时候，它会返回数据集的较早的一个版本，或者你可以配置成当主服务器宕机的时候从服务器给客户端返回连接错误。然而在某一个时刻，旧的数据集必须被删除，在新的数据载入之前，它还是会保持阻塞的状态拒绝进行连接请求。
```

Replications can be used both for scalability, in order to have multiple slaves for read-only queries (for example, heavy SORT operations can be offloaded to slaves, or simply for data redundancy.

It is possible to use replication to avoid the saving process on the master side: just configure your master redis.conf to avoid saving (just comment all the "save" directives), then connect a slave configured to save from time to time.

```
主从复制的结构可以为很多提供只读查询的应用提供良好的伸缩性（例如，重排序操作可以交给从服务器处理或者仅仅是想保持数据冗余）。甚至可以通过配置redis.conf文件来避免主服务器上进行数据持久化操作（仅仅是将配置文件中的saving指令全部注释），配置从服务器来完成数据持久化操作。
```

###How Redis replication works
###Redis主从结构如何工作

If you set up a slave, upon connection it sends a SYNC command. And it doesn't matter if it's the first time it has connected or if it's a reconnection.

The master then starts background saving, and collects all new commands received that will modify the dataset. When the background saving is complete, the master transfers the database file to the slave, which saves it on disk, and then loads it into memory. The master will then send to the slave all accumulated commands, and all new commands received from clients that will modify the dataset. This is done as a stream of commands and is in the same format of the Redis protocol itself.

```
如果你设置从服务器，给它发送一个同步的指令，至于是重新建连接还是使用老的连接是无关紧要的。主服务器在后台进行保存，收集所有修改数据集的新命令。当后台保存任务完成以后，主服务器传输数据库文件到从服务器的磁盘上，从服务器再把数据文件载入内存。主服务器会把收集到的所有命令和客户端发送的修改数据集的命令发送给从服务器。这些通过和redis协议相同格式的命令流来实现。
```

You can try it yourself via telnet. Connect to the Redis port while the server is doing some work and issue the SYNC command. You'll see a bulk transfer and then every command received by the master will be re-issued in the telnet session.

Slaves are able to automatically reconnect when the master <-> slave link goes down for some reason. If the master receives multiple concurrent slave synchronization requests, it performs a single background save in order to serve all of them.

When a master and a slave reconnects after the link went down, a full resync is performed.

```
你可以通过telnet命令来实现。连接到redis的端口，做些数据操作，然后发送同步命令。你将会看到数据批量传输和收到的telnet会补发的每个命令。不管什么原因，如果连接断掉，从服务器会尝试去重新连接主服务器。如果主服务器接受多个并发的从服务器请求，会执行单个后台保存操作。如果主从重新连接，也会重新执行同步操作。
```

###Configuration
###配置

To configure replication is trivial: just add the following line to the slave configuration file:

slaveof 192.168.1.1 6379

Of course you need to replace 192.168.1.1 6379 with your master IP address (or hostname) and port. Alternatively, you can call the SLAVEOF command and the master host will start a sync with the slave.

```
配置主从显得不足一提：仅仅是把下面这行添加到配置文件：
slaveof 192.168.1.1 6379
把19.168.1.1.和6379换成主服务器的ip地址（或者主机名）和端口。你也可以在服务器上面发送SLAVEOF命令，主服务器将会启动同步操作。
```

###Read only slave
###只读的从实例

Since Redis 2.6 slaves support a read-only mode that is enabled by default. This behavior is controlled by the slave-read-only option in the redis.conf file, and can be enabled and disabled at runtime using CONFIG SET.

Read only slaves will reject all the write commands, so that it is not possible to write to a slave because of a mistake. This does not mean that the feature is conceived to expose a slave instance to the internet or more generally to a network where untrusted clients exist, because administrative commands like DEBUG or CONFIG are still enabled. However security of read-only instances can be improved disabling commands in redis.conf using the rename-command directive.


```
在redis2.6版本以后，从服务器默认支持被配置成只读的。可以通过使用配置指令slave-read-only来指定只读的从服务器，运行时也可以通过CONFIG SET指令来禁用或者启用该选项。只读的从服务器将拒绝执行任何写操作的命令，所以不可能因为过失把数据写到从服务器上。这个设计并不是为了杜绝暴露在互联网的从服务器实例不信任客户端，因为像DEBUG或者CONFIG这类的命令仍然是启用的。然而安全的只读实例可以改善在redis配置文件中使用rename-command指定禁用命令的方式。
```

You may wonder why it is possible to revert the default and have slave instances that can be target of write operations. The reason is that while this writes will be discarded if the slave and the master will resynchronize, or if the slave is restarted, often there is ephemeral data that is unimportant that can be stored into slaves. For instance clients may take information about reachability of master in the slave instance to coordinate a fail over strategy.

```
你可能想知道，为什么可以把只读的从实例恢复成可以写的模式。原因在于，如果主从重新同步，写操作影响的数据可能会被丢失。或者从服务器实例重启，有些短暂的不重要的数据可以存储到从服务器上。例如连接从服务器的客户端可能需要取得一下主服务器到达性的信息来实现故障转移策略。
```