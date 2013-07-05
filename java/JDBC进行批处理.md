#JDBC进行批处理

* Statement.addBatch(sql) 
* PreparedStatement.addBatch()
* executeBatch()
* clearBatch()

###Statement.addBatch(sql)缺点
SQL语句没有预编译。当向数据库发送多条语句相同，但仅参数不同的SQL语句时，需重复写上很多条SQL语句。所以应该使用PreparedStatement.addBatch()，为了防止溢出，应该在固定sql数量的时候发送到一次数据库，然后clearBatch后继续。

```
try {
    conn = JdbcUtil.getConnection();
    String sql1 = "insert into user(name,password,email,birthday)  values('kkk','123','abc@sina.com','1978-08-08')";
    String sql2 = "update user set password='123456' where id=3";
    st = conn.createStatement();
    st.addBatch(sql1);  //把SQL语句加入到批命令中
    st.addBatch(sql2);  //把SQL语句加入到批命令中
    st.executeBatch();
    st.clearBatch();
} finally{
    JdbcUtil.free(conn, st, rs);
}
```

###PreparedStatement.addBatch()实现批处理的优缺点
发送的是预编译后的SQL语句，执行效率高。只能应用在SQL语句相同，但参数不同的批处理中。因此此种形式的批处理经常用于在同一个表中批量插入数据，或批量更新表的数据。

```
conn = JdbcUtil.getConnection();
String sql = "insert into user(name,password,email,birthday) values(?,?,?,?)";
st = conn.prepareStatement(sql);

for(int i = 0; i < 50000; i++) {
        st.setString(1, "aaa" + i);
        st.setString(2, "123" + i);
        st.setString(3, "aaa" + i + "@sina.com");
        st.setDate(4,new Date(1980, 10, 10));
        st.addBatch();

        if(i%1000==0){      
        //为防止(list集合) 内存溢出：设定每累加1000条数据就向数据库发送一次
					st.executeBatch();
					st.clearBatch();
        }
}

//当剩余的条数小于1000条时就不会被发送到数据库，所以此处要在发送一次
st.executeBatch();
```