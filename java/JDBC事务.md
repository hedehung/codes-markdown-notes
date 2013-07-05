#JDBC事务

1. 开启事务 Connection.setAutoCommit(false);
2. 回滚事务 Connection.rollback(); 
3. 提交事务 Connection.commit();

```
try {
  conn = JdbcUtils.getConnection();
  conn.setAutoCommit(false);    //start transaction;  开启事务
  
  String sql1 = "update account set money=money-100 where name='aaa'";
  String sql2 = "update account set money=money+100 where name='bbb'";
  
  st = conn.prepareStatement(sql1);
  st.executeUpdate();
  int x = 1 / 0;    // 人为制造异常，验证事务
  st = conn.prepareStatement(sql2);
  st.executeUpdate();
  conn.commit();    // Commit   提交事务
} finally {
  JdbcUtils.release(conn, st, rs);
} 
``` 


###设置事务回滚点 

```
Savepoint sp = conn.setSavepoint();
Conn.rollback(sp);
Conn.commit();   //回滚后必须要提交
```

###数据库共定义了四种隔离级别

(1) Serializable：可避免脏读、不可重复读、虚读情况的发生。（串行化，近似于单线程操作。）
(2) Repeatable read：可避免脏读、不可重复读情况的发生。（可重复读）
(3) Read committed：可避免脏读情况发生（读已提交）。
(4) Read uncommitted：最低级别，以上情况均无法保证。(读未提交)

set transaction isolation level 设置事务隔离级别
select @@tx_isolation  查询当前事务隔离级别

```
conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
conn.setAutoCommit(false);
```