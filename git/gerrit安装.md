# 主机
alias goodix='ssh wangbo@192.168.0.241'  
http://192.168.0.241:82/

# 目录
/var/www/gerrit/

# 帐号
admin 2QO8kdlc]  
jenkins 2QO8kdlc]  

新密码: 姓名+110  比如wangbo110

http password:

```
admin QRylT2+aCtWM  
wangbo ZjGmGBUYHE1Q  
jenkins Ci58yEPgrPu1
```  

# 同步帐号设置
帐号gerrit的私钥.ssh/gerrit_id_rsa.
ssh的config文件:

```
Host 192.168.0.241
    User git
    IdentityFile /home/wangbo/.ssh/gerrit_id_rsa
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    PreferredAuthentications publickey
```

# 同步到gitlab的插件配置
文件: /var/www/gerrit/etc/replication.config

```
[remote "gerrittest"]
  projects = gerrittest
  url = git@192.168.0.241:wangbo/gerrittest.git  
  push = +refs/heads/*:refs/heads/*
  push = +refs/tags/*:refs/tags/*
  push = +refs/changes/*:refs/changes/*
  threads = 3
```

# 本地访问gerrit的数据库

```
# ssh -p 29418 wangbo@192.168.0.241 gerrit gsql
```

# 删除项目的方法
通过命令`ssh -p 29418 wangbo@192.168.0.241 gerrit`查看，gerrit是没有直接提供删除项目的指令的.

### 第一种方法:

* 删除相应的仓库文件
* 进入数据库删除相应的ref记录，涉及到的表可能有projects,changes,ref_rights，根据gerrit的版本不同而有所不同

### 第二种方法:

使用delete-project插件:

[https://gerrit-review.googlesource.com/#/admin/projects/plugins/delete-project](https://gerrit-review.googlesource.com/#/admin/projects/plugins/delete-project)

```
ssh -p 29418 192.168.0.241 delete-project delete --yes-really-delete gerrittest
```

删除完之后，记得重新启动gerrit:

```
sudo service gerrit restart
```

# 设置push的快捷方式
编辑.git/config文件:

```
[remote "review"]
  pushurl = ssh://wangbo@192.168.0.241:29418/gerrittest.git
  push = HEAD:refs/for/master
  receivepack = git receive-pack --reviewer csfreebird
```
使用git push review来推送.

# 批量修改项目的设置

```
ssh -p 29418 wangbo@192.168.0.241 gerrit ls-projects
for p in $(cat projects) ; do ssh admin gerrit set-project $p -t FAST_FORWARD_ONLY;done
```

# 不允许直接push到HEAD指针的说明
[http://stackoverflow.com/questions/10461214/why-do-git-push-gerrit-headrefs-for-master-instead-of-git-push-origin-master](http://stackoverflow.com/questions/10461214/why-do-git-push-gerrit-headrefs-for-master-instead-of-git-push-origin-master)

# review的阀值

### Verified

```
-1: Fails
0: Have not tested
+1: Code works by testing
+2: Verification approved
```

### Code Review

```
+2: Verification approved
+1: Could commit, needs more approval
0: No opinion, just adding some comment
-1: Please do not commit
-2: Veto
```

两个+1并不等同于+2，+1表示有多少个人赞同这个变更.核心贡献者+2可以解锁submit功能.

# Python写的git review工具

```
git review -s 
// 询问gerrit用户名和自动安装commit-msg hooks钩子
```

等同于

```
git remote add gerrit ssh://wangbo@192.168.0.241:29418/gerrittest.git
scp -P 29418 wangbo@192.168.0.241:hooks/commit-msg .git/hooks/
```

使用git review可以简单的实现上传代码等待评审，否则就使用:

```
git push gerrit HEAD:refs/for/master
```

# 打回来的提交修改代码commit的时候带--amend选项，这样继续递交在原来的review单号上

```
git commit -a --amend
git review 或者 git review BRANCH_NAME
```

# 审批不通过的解决办法

```
git fetch origin
git rebase origin/master
// 这样能解决大部分冲突，如果需要手工解决，修改冲突文件，继续rebase
git add -u
git rebase --continue
// 递交审查
git commit -a --amend
git review 或者 git review BRANCH_NAME
```

解决冲突的过程解释见[http://www.mediawiki.org/wiki/Gerrit/resolve_conflict](http://www.mediawiki.org/wiki/Gerrit/resolve_conflict)

```
// download change
git-review -d <change #>
// start merge
git rebase origin/master
git status
<edit "both modified" files in status report>
git add <files>
git rebase --continue
// repost
git review
```

# 评审没有通过，但是分支已经删除

```
git fetch ssh://wangbo@192.168.0.241:29418/testing refs/changes/07/7/1 && git checkout FETCH_HEAD
git checkout -b my_branch
// 修改完成后commit提交评审git review
```

# master分支，release分支，递交进入master的分支中，有某个bugfix或者新特性需要合并回release分支

```
git fetch --all
git checkout -b rfc/4-4/1234 origin/<release-branch>
git cherry-pick <revision-id>
```

# 去掉Change-Id, Reviewed-*, Tested-by等日志信息

```
git commit -a --amend
git review <release-branch>
```

# git review -s做的事情

* checks whether accessing the remote repository works
* if it doesn't, asks for a username and tries again
* creates a remote called 'gerrit' that points to gerrit
* installs the commit-msg hook

# git review做的事情

* it looks up which branch to push to (production or whatever) in the .gitreview file. If it can't find this information, it pushes to master
* it figures out what "topic" to put on the revision (you can set the topic manually with -t)
  - if you're resubmitting a downloaded change, it will reuse the tag of the original change
  - if your commit summary contains a bug number like bug 12345, the tag will be bug/12345
  - otherwise, the tag will be the name of your local branch
* it rebases your change against the HEAD of the branch you're pushing to (use -R to skip this)
* if you are submitting more than one change at once, or submitting a change that's based on another unmerged change, it will ask you whether you really meant to do that (use -y to skip this)
* it pushes the change for review

# git-review的-f参数
提交成功后阐述本地分支，切换回来源分支.

```
# (production) git checkout -b mycoolfeature
# (mycoolfeature) vi foobar
# (mycoolfeature) git commit -a -m "Committing my cool feature"
# (mycoolfeature) git review -f
# (production) git branch -a
```

# 配置.gitreview文件

```
[gerrit]
host=192.168.0.241
port=29418 // 默认是29418
project=wangbo/gerrit.git
defaultremote=gerrit // 默认是gerrit
defaultbranch=develop // 默认是master
```

Optional values: 

* port (default: 29418)
* defaultbranch (default: master)
* defaultremote (default: gerrit)

git-review的简介和基本使用方法见[http://www.mediawiki.org/wiki/Gerrit/git-review](http://www.mediawiki.org/wiki/Gerrit/git-review)  
git-review的github地址见[https://github.com/openstack-infra/git-review](https://github.com/openstack-infra/git-review)