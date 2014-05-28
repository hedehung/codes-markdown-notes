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

# 克隆gerrit工程到本地

```
# git clone ssh://wangbo@192.168.0.241:29418/gerrittest
```

# 更换下别名方便管理

```
git remote rename origin gerrit
```

或者

```
# git remote add gerrit ssh://wangbo@192.168.0.241:29418/gerrittest
# git remote remove origin
```

# 安装钩子以便创建Change-Id

```
# scp -p -P 29418 wangbo@192.168.0.241:hooks/commit-msg .git/hooks
# chmod +x .git/hooks/commit-msg
```

# 修改代码提交到暂存区

```
# touch main.c
# git add main.c
# git ci -m 'init main'
```

# push到gerrit服务器

```
# 建设是master分支
# git push gerrit HEAD:refs/for/master
```

# 在gerrit系统中查看提交的修改
All->open或My->changes标签下面.

# 代码审查者在gerrit中进行审查
进行评级和打分，决定submit还是reject.