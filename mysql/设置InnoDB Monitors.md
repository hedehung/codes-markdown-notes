针对Innodb 类型的表，如果需要察看当前的锁等待情况，可以设置InnoDB Monitors，然后通过Show innodb status 察看。
	CREATE TABLE innodb_monitor(a INT) ENGINE=INNODB;
监视器可以通过发出下列语句来被停止
	DROP TABLE innodb_monitor;

设置监视器后，在show innodb status 的显示内容中，会有详细的当前锁等待的信息，包括表名、锁类型、锁定记录的情况等等，便于进行进一步的分析和问题的确定。打开监视器以后，默认情况下每15 秒会向日志中记录监控的内容，如果长时间打开会导致.err 文件变得非常的巨大，所以我们在确认问题原因之后，要记得删除监控表以关闭监视器。或者通过使用--console 选项来启动服务器以关闭写日志文件。
