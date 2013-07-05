#获取插入主键

```
Connection conn = JdbcUtil.getConnection(); 
String sql = "insert into user(name,password,email,birthday)  values('abc','123','abc@sina.com','1978-08-08')";
PreparedStatement st = conn.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS );         
st.executeUpdate();
ResultSet rs = st.getGeneratedKeys();  //得到插入行的主键

//此参数仅对insert操作有效
if(rs.next())
        System.out.println(rs.getObject(1));
```