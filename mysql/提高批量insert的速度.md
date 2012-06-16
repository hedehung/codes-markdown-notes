###优化insert语句
*使用多个值表的INSERT 语句。这比使用分开INSERT 语句快(在一些情况中几倍)。
	Insert into test values(1,2),(1,3),(1,4)…
*通过使用INSERT DELAYED 语句得到更高的速度。Delayed 的含义是让insert 语句马上执行，其实数据都被放在内存的队列中，并没有真正写入磁盘；这比每条语句分别插入要快的多；LOW_PRIORITY 刚好相反，在所有其他用户对表的读写完后才进行插入。
*将索引文件和数据文件分在不同的磁盘上存放（利用建表中的选项）。
*如果进行批量插入，可以增加bulk_insert_buffer_size 变量值的方法来提高速度，但是，这只能对myisam 表使用。
*当从一个文本文件装载一个表时，使用LOAD DATA INFILE。这通常比使用很多INSERT 语句快20 倍。
*根据应用情况使用replace 语句代替insert。
*根据应用情况使用ignore 关键字忽略重复记录。
