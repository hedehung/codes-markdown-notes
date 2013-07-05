#JDBC处理大数据

###保存MySQL的Text数据

```
PreparedStatement.setCharacterStream(i, reader, length);
```

###获取MySQL的Text数据

```
reader = resultSet. getCharacterStream(i);
// 或者
reader = resultSet.getClob(i).getCharacterStream();
// 或者
string s = resultSet.getString(i);
```

###保存MySQL二进制数据

```
PreparedStatement. setBinaryStream(i , inputStream, length);
```

###读取MySQL二进制数据

```
InputStream in  = resultSet.getBinaryStream(i);
InputStream in  = resultSet.getBlob(i).getBinaryStream();
```

###Oracle处理大数据
Oracle定义了一个BLOB字段用于保存二进制数据，但这个字段并不能存放真正的二进制数据，只能向这个字段存一个指针，然后把数据放到指针所指向的Oracle的LOB段中， LOB段是在数据库内部表的一部分。操作Oracle的Blob之前，必须获得指针（定位器）才能进行Blob数据的读取和写入。方法是调用empty_blob()。

###Oracle中LOB类型的处理步骤
(1) 插入空blob —— insert into test(id,image) values(?, empty_blob());
(2) 获得blob的cursor —— select image from test where id = ? for update;  
//须加for update，锁定该行，直至该行被修改完毕，保证不产生并发冲突。
Blob b = rs.getBlob(“image”);