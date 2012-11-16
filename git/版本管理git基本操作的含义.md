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

3. 将改动提交到远端仓库（master可以是任何远端仓库）
```
git push origin master
```

###分支管理
1. 创建分支
```
git checkout -b feature_x 
```
2. 切换回主分支
```
git checkout master 
```
3. 删除分支
```
git branch -d feature_x
```
4. 将分支推送到远端仓库一遍他人可见 
```
git push origin <分支名称>
```

### 更新和合并
1. 更新本地仓库到最新改动 
```
git pull 
```
2. 合并 
```
git merge <分支名称>
git merge --no-ff <分支名称>
```
3. 合并改动之前查看修改
```
git diff <source_branch> <target_branch>
```

###创建标签
```
git tag 1.0.0 1b2e1d63ff
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
4. develop分支经过测试并且决定发布版本后创建出release分支 
5. release分支用于修复bug,修复的bug分支为bugfix
6. bugfix分支完成后需要合并到release分支上,并删除bugfix分支
6. release分支完成后需要合并到develop和master分支,并为master打上tag,并且删除release分支
```
git checkout master 
git merge --no-ff release
git tag -a 1.2 
git checkout develop 
git merge --no-ff release 
git branch -d release
```
7. 如果线上的tag版本出现bug则从master上创建hotfix分支进行修复
8. hotfix分支修复后合并到master和develop分支,然后删除hotfix分支
9. 只有有release分支,出现的bug分支就合并到release上面,因为release最后也回合并到develop分支上
