使用--execute（-e）选项
```
mysql -u root -p -e "SELECT User, Host FROM User" mysql
```
可以按这种方式传递多个SQL 语句，用分号隔开：
```
shell> mysql -u root -p -e "SELECT Name FROM Country WHERE Name LIKE 'AU%';SELECT COUNT(*) FROM City" world
Enter password: ******
+-----------+
| Name |
+-----------+
| Australia |
| Austria |
+-----------+
+----------+
| COUNT(*) |
+----------+
| 4079 |
+----------+
```
请注意长形式(--execute)后面必须紧跟一个等号(=)。
