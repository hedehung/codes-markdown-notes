###key_buffer_size 的设置
键缓存(变量key_buffer_size) 被所有线程共享；服务器使用的其它缓存则根据需要分配。此参数只适用于myisam 存储引擎。
使用方法：
mysql5.1 以前只允许使用一个系统默认的key_buffer
mysql5.1 以后提供了多个key_buffer，可以将指定的表索引缓存入指定的key_buffer，这样可以更小的降低线程之间的竞争，相关语法如下：例如，下面的语句将表t1、t2 和t3 的索引分配给名为hot_cache 的键高速缓冲：
	mysql> CACHE INDEX t1, t2, t3 IN hot_cache;
可以用SET GLOBAL 参数设置语句或使用服务器启动选项设置在CACHE INDEX 语句中引用的键高速缓冲的大小来创建键高速缓冲。例如：
	mysql> SET GLOBAL keycache1.key_buffer_size=128*1024;
要想删除键高速缓冲，将其大小设置为零：
	mysql> SET GLOBAL keycache1.key_buffer_size=0;
请注意不能删除默认键高速缓冲。删除默认键高速缓冲的尝试将被忽略CACHE INDEX 在一个表和键高速缓冲之间建立一种联系，但每次服务器重启时该联系被丢失。如果你想要每次服务器重启时该联系生效，一个发办法是使用选项文件：包括配置键高速缓冲的变量设定值，和一个init-file 选项用来命名包含待执行的
CACHE INDEX 语句的一个文件。例如：
	key_buffer_size = 4G
	hot_cache.key_buffer_size = 2G
	cold_cache.key_buffer_size = 2G
	init_file=/path/to/data-directory/mysqld_init.sql
每次服务器启动时执行mysqld_init.sql 中的语句。该文件每行应包含一个SQL 语句。
下面的例子分配几个表，分别对应hot_cache 和cold_cache：
	CACHE INDEX a.t1, a.t2, b.t3 IN hot_cache
	CACHE INDEX a.t4, b.t5, b.t6 IN cold_cache
要想将索引预装到缓存中，使用LOAD INDEX INTO CACHE 语句。例如，下面的语句可以预装表t1 和t2 索引的非叶节点(索引块)：
	mysql> LOAD INDEX INTO CACHE t1, t2 IGNORE LEAVES;
键高速缓冲可以通过更新其参数值随时重新构建。例如：
	mysql> SET GLOBAL cold_cache。key_buffer_size=4*1024*1024；
如果你很少使用MyISAM 表，那么也保留低于16-32MB 的key_buffer_size 以适应给予磁盘的临时表索引所需。

###table_cache的设置
数据库中打开表的缓存数量。table_cache 与max_connections 有关。例如，对于200 个并行运行的连接，应该让表的缓存至少有200 * N，这里N 是可以执行的查询的一个联接中表的最大数量。还需要为临时表和文件保留一些额外的文件描述
符。
设置技巧：可以通过检查mysqld 的状态变量Opened_tables 确定表缓存是否太小：
	mysql> SHOW STATUS LIKE 'Opened_tables';
	+---------------+-------+
	| Variable_name | Value |
	+---------------+-------+
	| Opened_tables | 2741 |
	+---------------+-------+
如果值很大，即使你没有发出许多FLUSH TABLES 语句，也应增加表缓存的大小。

###innodb_buffer_pool_size 的设置
缓存InnoDB 数据和索引的内存缓冲区的大小。你把这个值设得越高，访问表中数据需要得磁盘I/O 越少。在一个专用的数据库服务器上，你可以设置这个参数达机器物理内存大小的80%。尽管如此，还是不要把它设置得太大，因为对物理内存的竞争可能在操作系统上导致内存调度。

###innodb_flush_log_at_trx_commit 的设置
0：日志缓冲每秒一次地被写到日志文件，并且对日志文件做到磁盘操作的刷新，但是在一个事务提交不做任何操作。 
1：在每个事务提交时，日志缓冲被写到日志文件，对日志文件做到磁盘操作的刷新。  
2：在每个提交，日志缓冲被写到文件，但不对日志文件做到磁盘操作的刷新。对日志文件每秒刷新一次。  
默认值是1，也是最安全的设置，即每个事务提交的时候都会从log buffer 写到日志文件，而且会实际刷新磁盘，但是这样性能有一定的损失。如果可以容忍在数据库崩溃的时候损失一部分数据，那么设置成0 或者2 都会有所改善。设置成0，则在数据库崩溃的时候会丢失那些没有被写入日志文件的事务，最多丢失1 秒钟的事务，这种方式是最不安全的，也是效率最高的。设置成2 的时候，因为只是没有刷新到磁盘，但是已经写入日志文件，所以只要操作系统没有崩溃，那么并没有丢失数据，比设置成0 更安全一些。在mysql 的手册中，为了确保事务的持久性和复制设置的耐受性、一致性，都是建议将这个参数设置为1 的。

###innodb_additional_mem_pool_size
InnoDB 用来存储数据目录信息和其它内部数据结构的内存池的大小。默认值是1MB。应用程序里的表越多，你需要在这里分配越多的内存。如果InnoDB 用光了这个池内的内存，InnoDB 开始从操作系统分配内存，并且往MySQL 错误日志写警告信息。没有必要给这个缓冲池分配非常大的空间，在应用相对稳定的情况下，这个缓冲池的大小也相对稳定。

###innodb_table_locks
InnoDB 重视LOCK TABLES，直到所有其它线程已经释放他们所有对表的锁定，MySQL 才从LOCK TABLE .. WRITE 返回。默认值是1，这意为LOCK TABLES 让InnoDB内部锁定一个表。在使用AUTOCOMMIT=1 的应用里，InnoDB 的内部表锁定会导致死锁。可以通过设置innodb_table_locks=0 来消除这个问题。

###innodb_lock_wait_timeout
Mysql 可以自动的监测行锁导致的死锁并进行相应的处理，但是对于表锁导致的死锁不能自动的监测，所以该参数主要被用来在出现类似情况的时候对锁定进行的后续处理。默认值是50 秒，根据应用的需要进行调整。

###innodb_support_xa
通过该参数设置是否支持分布式事务，默认值是ON 或者1，表示支持分布式事务。如果确认应用中不需要使用分布式事务，则可以关闭这个参数，减少磁盘刷新的次数并获得更好的InnoDB 性能。

###innodb_doublewrite
默认地，InnoDB 存储所有数据两次，第一次存储到doublewrite 缓冲，然后存储到确实的数据文件。如果对性能的要求高于对数据完整性的要求，那么可以通过-- skip-innodb-doublewrite 关闭这个设置。

###innodb_log_buffer_size
默认的设置在中等强度写入负载以及较短事务的情况下，服务器性能还可以。如果存在更新操作峰值或者负载较大，就应该考虑加大它的值了。如果它的值设置太高了，可能会浪费内存-- 它每秒都会刷新一次，因此无需设置超过1 秒所需的内存空间。通常8-16MB 就足够了。越小的系统它的值越小。

###innodb_log_file_size
在高写入负载尤其是大数据集的情况下很重要。这个值越大则性能相对越高，但是要注意到可能会增加恢复时间。
