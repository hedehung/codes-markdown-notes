###生成最后一个提交对应的patch文件
```
git format-patch -1
```

###把一个patch文件加到git仓库
```
git am < patch 
```

###如果有冲突,在解决冲突后执行
```
git am --resolved
```

###放弃当前git am所引入的patch
```
git am --skip
```
