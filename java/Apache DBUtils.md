#Apache DBUtils

* org.apache.commons.dbutils.QueryRunner  
* org.apache.commons.dbutils.ResultSetHandler 

###DbUtils类 

* public static void close(…) throws java.sql.SQLException：　DbUtils类提供了三个重载的关闭方法。这些方法检查所提供的参数是不是NULL，如果不是的话，它们就关闭Connection、Statement和ResultSet。

* public static void closeQuietly(…): 这一类方法不仅能在Connection、Statement和ResultSet为NULL情况下避免关闭，还能隐藏一些在程序中抛出的SQLException。

* public static void commitAndCloseQuietly(Connection conn)： 用来提交连接，然后关闭连接，并且在关闭连接时不抛出SQL异常。 

* public static boolean loadDriver(java.lang.String driverClassName)：这一方装载并注册JDBC驱动程序，如果成功就返回true。使用该方法，你不需要捕捉这个异常ClassNotFoundException。

###QueryRunner类 

* QueryRunner() 
* QueryRunner(DataSource ds)
* public Object query(Connection conn, String sql, Object[] params, ResultSetHandler rsh) throws SQLException：执行一个查询操作，在这个查询中，对象数组中的每个元素值被用来作为查询语句的置换参数。该方法会自行处理 PreparedStatement 和 ResultSet 的创建和关闭。
* public Object query(String sql, Object[] params, ResultSetHandler rsh) throws SQLException:　几乎与第一种方法一样；唯一的不同在于它不将数据库连接提供给方法，并且它是从提供给构造方法的数据源(DataSource) 或使用的setDataSource 方法中重新获得 Connection。 
* public Object query(Connection conn, String sql, ResultSetHandler rsh) throws SQLException : 执行一个不需要置换参数的查询操作。 
* public int update(Connection conn, String sql, Object[] params) throws SQLException:用来执行一个更新（插入、更新或删除）操作。
* public int update(Connection conn, String sql) throws SQLException：用来执行一个不需要置换参数的更新操作。

###QueryRunner示例

```
public void insert() throws SQLException {
	QueryRunner runner = new QueryRunner(JdbcUtils.getDataSource());
	String sql = "insert into users(id,name,password,email,birthday) values(?,?,?,?,?)";
	Object params[] = {2,"bbb","123","aa@sina.com",new Date()};
	runner.update(sql, params);
}

public void update() throws SQLException {
	QueryRunner runner = new QueryRunner(JdbcUtils.getDataSource());
	String sql = "update users set email=? where id=?";
	Object params[] = {"aaaaaa@sina.com",1};
	runner.update(sql, params);
}

public void find() throws SQLException {
	QueryRunner runner = new QueryRunner(JdbcUtils.getDataSource());
	String sql = "select * from users where id=?";
	User user = (User) runner.query(sql, 1, new BeanHandler(User.class));
	System.out.println(user.getEmail());
}

public void getAll() throws Exception {
	QueryRunner runner = new QueryRunner(JdbcUtils.getDataSource());
	String sql = "select * from users";
	List list = (List) runner.query(sql, new BeanListHandler(User.class));
	System.out.println(list);
}

public void batch() throws SQLException{
	QueryRunner runner = new QueryRunner(JdbcUtils.getDataSource());
	String sql =  "insert into users(id,name,password,email,birthday) values(?,?,?,?,?)";
	Object params[][] = new Object[3][5];
	
	for(int i=0;i<params.length;i++) {  //3
		params[i] = new Object[]{i+1,"aa"+i,"123",i + "@sina.com",new Date()};
	}
	
	runner.batch(sql, params);
} 
```

###ResultSetHandler 接口的实现类
* ArrayHandler( )：把结果集中的第一行数据转成对象数组
* ArrayListHandler( )：把结果集中的每一行数据都转成一个数组，再存放到List中
* BeanHandler(Class type) ：将结果集中的第一行数据封装到一个对应的JavaBean实例中
* BeanListHandler(Class type) ：将结果集中的每一行数据都封装到一个对应的JavaBean实例中，存放到List里
* ColumnListHandler(int columnIndex / String columnName)：将结果集中某一列的数据存放到List中
* KeyedHandler( int columnIndex / String columnName )：将结果集中的每一行数据都封装到一个Map里，再把这些map再存到一个map里，并将其columnName的值作为指定的key
* MapHandler( )：将结果集中的第一行数据封装到一个Map里，key是列名，value就是对应的值
* MapListHandler( )：将结果集中的每一行数据都封装到一个Map里，然后再存放到List
* ScalarHandler( )：将结果集中的某一列 装入到一个对象中