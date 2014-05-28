git cherry-pick用于把另一个本地分支的commit修改应用到当前分支，比如在master上面做了修改，哈希码是417ea6e，切换到cherry分支，执行:
	
```
git cherry-pick 417ea6e
```

这个时候在cherry分支上面将生成新的哈西码，并且把417ea6e提交的变更和commit信息都复制了过来。同样的，执行的过程中没有变更后者顺序交换，rebase同样的可以把变更拿过来，但是执行:

```
git rebase master
```

后，git lg发现在cherry分支上面的变更的哈西码和master相同。如果有冲突的话，rebase会有2个哈西码，一个是和master的哈西码相同，一个是新生成的。git cherry-pick同样可能产生冲突，和rebase相似，使用交互命令完成:

```
git cherry-pick --continue
git cherry-pick --quit
git cherry-pick --abort
```

如果解决冲突后需要提交，要带上-c参数，也就是`git ci -c 原commit号`提交。