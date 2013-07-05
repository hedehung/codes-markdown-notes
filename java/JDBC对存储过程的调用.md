#JDBC对存储过程的调用 

```
CREATE PROCEDURE demoSp (IN inputParam VARCHAR(255) ,INOUT  inOutParam varchar(255))
		BEGIN
			SELECT CONCAT ('ZYXW---- ', inputParam) into inOutParam;
		END
```

### 得到CallableStatement，并调用存储过程

```
CallableStatement cStmt = conn.prepareCall("{call demoSp(?, ?)}");  
```

### 设置参数，注册返回值，得到输出

```
cStmt.setString(1, "abcdefg");
// java.sql.Types
cStmt.registerOutParameter(2, Types.VARCHAR); 
cStmt.execute();
System.out.println(cStmt.getString(2));
```

###示例

```
Connection conn = null;
CallableStatement  st = null;
ResultSet rs = null;

try {
    conn = JdbcUtils.getConnection();
    st = conn.prepareCall("{call demoSp(?,?)}");
    st.setString(1, "aaaaa");
    st.registerOutParameter(2, Types.VARCHAR);
    st.execute();
    System.out.println(st.getString(2)); 
} finally {
  JdbcUtils.release(conn, st, rs);
}
```