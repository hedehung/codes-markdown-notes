###显示修改过的文件
```
git ls-files -m
```

###显示所有仓库中的文件
```
git ls-files
```

###显示file在HEAD中的SHA1值
```
git ls-tree HEAD file
```

###显示一个SHA1的类型
```
git cat-files -t SHA1
```

###显示一个SHA1的内容,type是blob,tree,commit,tag之一
```
git cat-file type SHA1
```

###查看已经删除的文件
```
git ls-files -d
```

###将已删除的文件还原
```
git ls-files -d | xargs git checkout
```
