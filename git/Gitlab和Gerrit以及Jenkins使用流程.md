# 在gitlab中创建工程并且clone仓库到本地

```
# mkdir gerrittest
# cd gerrittest
# git init
# touch README
# git add README
# git commit -m 'first commit'
# git remote add origin git@192.168.0.241:wangbo/gerrittest.git
# git push -u origin master
```

# 在gitlab的gerrittest工程members管理中添加gerrit为master成员

# 测试gerrit帐号的可访问性

```
# ssh -p 29418 wangbo@192.168.0.241
```

正常返回:

```
****    Welcome to Gerrit Code Review    ****

  Hi wangbo, you have successfully connected over SSH.

  Unfortunately, interactive shells are disabled.
  To clone a hosted Git repository, use:

  git clone ssh://wangbo@192.168.0.241:29418/REPOSITORY_NAME.git

Connection to 192.168.0.241 closed.
```

# 使用admin帐号在gerrit中创建相应的工程或者使用命令行(要求帐号有create-project权限)

```
# 命令行
# ssh -p 29418 wangbo@192.168.0.241 gerrit create-project --empty-commit --name gerrittest
```

# 将gitlab的git仓库克隆到gerrit的git目录下面

```
# cd /var/www/gerrit/git
# rm -rf gerrittest.git/
# git clone --bare http://192.168.0.241/wangbo/gerrittest.git
```

现在的目录:

```
drwxrwxr-x  5 wangbo wangbo 4096  5月 23 11:19 ./
drwxrwxr-x 12 wangbo wangbo 4096  5月 22 11:55 ../
drwxrwxr-x  7 wangbo wangbo 4096  5月 22 11:55 All-Projects.git/
drwxrwxr-x  7 wangbo wangbo 4096  5月 23 11:19 gerrittest.git/
drwxr-xr-x  7 wangbo wangbo 4096  5月 22 17:42 HotKnotService.git/
```

# 将gerrit的仓库和克隆到本地

```
# git clone ssh://wangbo@192.168.0.241:29418/gerrittest
```
克隆下来有README文件:

```
-rw-r--r--  1 bob  admin     0B  5 23 11:20 README
```

# 克隆gerrit工程到本地

```
# git clone ssh://wangbo@192.168.0.241:29418/gerrittest
```

# 更换下别名方便管理

```
# git remote add gerrit ssh://wangbo@192.168.0.241:29418/gerrittest
# git remote remove origin
# git remote -v
```

# 安装钩子以便创建Change-Id

```
# scp -p -P 29418 wangbo@192.168.0.241:hooks/commit-msg .git/hooks
# chmod +x .git/hooks/commit-msg
```

# 实现变更后自动同步到gitlab仓库
进入gerrit服务器:

```
# cd /var/www/gerrit/
# vim etc/replication.config
```

加入:

```
[remote "gerrittest"]
  # Gerrit 上要同步项目的名字
  projects = gerrittest
  url = gerrit@192.168.0.241:/home/git/repositories/wangbo/gerrittest.git  
  push = +refs/heads/*:refs/heads/*
  push = +refs/tags/*:refs/tags/*
  push = +refs/changes/*:refs/changes/*
  threads = 3
```

重启gerrit:

```
sudo service gerrit restart
```

# 修改代码提交到暂存区

```
# touch main.c
# git add main.c
# git ci -m 'init main'
```

# push到gerrit服务器

```
# git push gerrit HEAD:refs/for/master
```

输出:

```
Counting objects: 3, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (2/2), 274 bytes | 0 bytes/s, done.
Total 2 (delta 0), reused 0 (delta 0)
remote: Processing changes: new: 1, refs: 1, done    
remote: 
remote: New Changes:
remote:   http://192.168.0.241:82/2
remote: 
To ssh://wangbo@192.168.0.241:29418/gerrittest
 * [new branch]      HEAD -> refs/for/master
```

# 在gerrit系统中查看提交的修改

```
All->open或My->changes标签下面
```

# 代码审查者在gerrit中进行审查
进行评级和打分，决定submit还是reject