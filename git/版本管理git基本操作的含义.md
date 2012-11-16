###git文件三种状态
1. commited已提交,文件已经安全的保存到本地数据库.
2. modified已修改,文件被修改但是还没有提交保存.
3. staged已暂存,把已修改的文件保存到下次要提交的保存清单中.

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
```
git commit -m "改动消息"
```
3. 将改动提交到远端仓库    
```
git push origin master
```

###分支管理 
1. 创建分支   
```
git checkout -b feature_x 或 git checkout -b feature_x develop
``` 
2. 切换回主分支   
```
git checkout master 
```
3. 删除分支        
```
git branch -d feature_x
```
4. 将分支推送到远端仓库以便他人可见   
```
git push origin 分支名称
```

###更新和合并   
1. 更新本地仓库到最新改动  
```
git pull 
```
2. 合并  
```
git merge 分支名称 或 git merge --no-ff 分支名称
```
3. 合并改动之前查看修改   
```
git diff <source_branch> <target_branch>
```

###查看改变
1. 未暂存的文件更新哪些部分
```
git diff 
```
2. 已经暂存的文件和上次提交的快照之间的差别
```
git diff --cached
```

###删除文件
```
git rm 文件 或 git rm -f 文件
```

###从跟踪清单中移除保留文件,以便稍后在.gitignore文件中补上
```
git rm --cached 文件或目录
```

###查看远端仓库的详细信息
```
git remote show origin
```

###远端仓库重命名
```
git remote rename 旧名称 新名称
```

###移除远端仓库
```
git remote rm 名称 或 git push origin :名称(助记:把空推送到远端分支)
```

###创建标签
```
git tag 1.0.0 1b2e1d63ff 或 git tag -a v1.2 -m '稳定1.2版本'
```

###列标签
```
git tag 或者 git tag -l "v1.4.*"
```

###查看相应标签的版本信息
```
git show v1.4
```

###用HEAD的内容替换掉本地修改
```
git checkout -- <filename>
```
但是这个命令不影响已经提交到缓存的改动和新文件

###丢弃所有的本地改动并获取服务器的最新的分支
```
git fetch origin 
git reset --hard origin/master
```

###git开发管理分支之道
1. 开发分支develop 
2. 新的功能feature分支 
3. feature开发完成合并到develop分支上
4. develop分支经过测试并且决定发布版本后创建出release-1.x分支 
5. release-1.x分支用于修复bug,修复的bug分支为bugfix
6. bugfix分支完成后需要合并到release-1.x分支上,并删除bugfix分支
6. release-1.x分支完成后需要合并到develop和master分支,并为master打上tag,并且删除release-1.x分支
7. 如果线上的tag版本出现bug则从master上创建hotfix分支进行修复
8. hotfix分支修复后合并到master和develop分支,然后删除hotfix分支
9. 只有有release-1.x分支,出现的bug分支就合并到release-1.x上面,因为release-1.x最后也回合并到develop分支上

###上面第6步说明
```
git checkout master 
git merge --no-ff release-1.x
git tag -a 1.x
git checkout develop 
git merge --no-ff release-1.x
git branch -d release-1.x
```

###某些tips  
1. 简短的状态信息
```
git status -sb
```
2. 日志显示分支和tag
```
git log --oneline --decorate
```
3. 推送分支并且启动跟踪
```
git push -u origin master 或 git config --global push.default tracking
```
4. 跟踪其他人的远端分支
```
git checkout -t origin/feature_from_bob
```
5. 用--rebase参数
```
git pull --rebase 
```
在master上相当于git fetch origin,否则相当于git rebase origin/master
6. 找出改动所在的release
```
git name-rev --name-only 50f3754
```
7. 找出哪些分支包含了改变
```
git branch --contains 50f3754
```
8. 查询包含某个注释的上次提交
```
git show :/fix 或 git show :/^Merge
```
