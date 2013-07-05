#JDBC的标准步骤

### 1) 加载驱动(两种写法)

```
//这种方式会注册两个Driver对象,因为用类名类直接创建对象,所以编译的时候需要导入相应的jar包,不推荐使用这种方式
DriverManager. registerDriver(new com.mysql.jdbc.Driver());
//或者(使用字符串,不依赖于具体的驱动库,灵活,不会重复创建Driver对象)
Class.forName(“com.mysql.jdbc.Driver”);
```

### 2) 获取数据库链接

```
//不要用具体的驱动类型
Connection conn = DriverManager.getConnection(url, username, password);
```

### 3) 获取statament对象

```
Statement st = conn.createStatement();
```

### 4) 向数据库发送sql，获取数据库返回的结果集

```
ResultSet rs = st.executeQuery("select * from users");
```

### 5) 处理数据

```
while(rs.next()) {
	//映射到java对象中
	System.out.println("id=" + rs.getObject("id"));
  System.out.println("name=" + rs.getObject("name")); 
}
```

### 6) 关闭链接,注意顺序,要放在finally块中

```
rs.close();
st.close();
conn.close();
```

###数据库协议字符串
Oracle写法: jdbc:oracle:thin:@localhost:1521:sid  
SqlServer: jdbc:microsoft:sqlserver://localhost:1433; DatabaseName=sid  
MySql: jdbc:mysql://localhost:3306/sid
Mysql的url简写: jdbc:mysql:///sid  
常用属性:  useUnicode=true&characterEncoding=UTF-8  

###Connection常用的方法

* createStatement()：创建向数据库发送sql的statement对象
* prepareStatement(sql)：创建向数据库发送预编译sql的PrepareSatement对象
* prepareCall(sql)：创建执行存储过程的callableStatement对象
* setAutoCommit(boolean autoCommit)：设置事务是否自动提交
* commit()：在链接上提交事务
* rollback()：在此链接上回滚事务

###Statement常用方法

* executeQuery(String sql)：用于向数据库发送查询语句
* executeUpdate(String sql)：用于向数据库发送insert、update或delete语句
* execute(String sql)：用于向数据库发送任意sql语句
* addBatch(String sql)：把多条sql语句放到一个批处理中
* executeBatch()：向数据库发送一批sql语句执行
* clearBatch()：清空此 Statement 对象的当前 SQL 命令列表

###ResultSet常用移动游标的方法

* next()：移动到下一行
* previous()：移动到前一行
* absolute(int row)：移动到指定行
* beforeFirst()：移动resultSet的最前面
* afterLast()：移动到resultSet的最后面

###ResultSet对象获取数据的方法

* getObject
* getBoolean
* getBytes
* getByte
* getShort
* getInt
* getLong
* getString
* getClob
* getBlob
* getDate
* getTime
* getTimestamp

Connection对象是非常稀有的资源，用完后必须马上释放，如果Connection不能及时、正确的关闭，极易导致系统宕机。Connection的使用原则是尽量晚创建，尽量早的释放。为确保资源释放代码能运行，资源释放代码也一定要放在finally语句中。防范sql注入用PreparedStatement取代Statement。