###复制表的数据
```
CREATE TABLE messages_test LIKE messages;
ALTER TABLE messages_test ENGINE=MyISAM;
INSERT INTO messages_test SELECT * FROM messages;
```
或者是使用事务分段复制
```
START TRANSACTION;
INSERT INTO messages_test SELECT * FROM messages WHERE id BETWEEN x AND y;
COMMIT;
```
以上操作可以在几秒中dup几十万级别的数据，速度还是非常快，几百上千万就需要更长的时间了，非常的好用，但是有个缺点:
FROM后的表会被锁定，如果messages是处在上线状态，加上这个复制的IO将很可能导致这段复制的时间内，业务系统无法正常的
读写数据，造成数据库系统的客户端应用宕机。

改善的办法是把数据dump到外部文件后，修改表的定义后，再导入到新表中。
