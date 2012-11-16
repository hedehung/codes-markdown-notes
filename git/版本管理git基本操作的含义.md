###初始化
```
mkdir project_dir && cd project_dir && git init
```

###克隆仓库   
```
git clone username@host:/path/to/repository
```
其中username通常是git用户

###本地仓库的三棵树
1. 含有实际文件的工作目录
2. 缓存区Index
3. HEAD最后一次提交的结果

###改动
1. 把改动添加到缓存区
```
git add .
```
2. 提交到HEAD（但是没有提交到远端仓库） 
git commit -m "改动消息"

3. 将改动提交到远端仓库
```
git push origin master
```
