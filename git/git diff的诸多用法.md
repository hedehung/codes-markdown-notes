### 直接比较当前开发后的改动
```
git diff
```

###比较tag和HEAD之间的不同
```
git diff tag
#或指定文件
git diff tag file
```

###比较两个tag之间的不同
```
git diff tag1..tag2
```

###比较两个提交之间的不同
```
git diff SHA1..SHA2
#或
git diff tag1 tag2 file
#或
git diff tag1:file tag2:file 
```

###ORIG_HEAD用于指向前一个操作状态,因此在git pull之后如果想得到pull的内容
```
git diff ORIG_HEAD
```

###生成统计信息
```
git diff --stat
git diff --stat ORIG_HEAD
```
