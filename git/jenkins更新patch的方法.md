#jenkins更新patch的方法

Jenkins 在做构建之前会从 Gerrit 上 git clone 项目的源代码，而刚才提交代码到了 refs/changes/ 下，并没有 merge 到 refs/heards 上，故 Jenkins 是不会 check 到最近提交的代码的。

在 Jenkins Projects 中的 Execute shell 加入下面几行命令：

```
cd $WORKSPACE

git fetch ssh://wangbo@192.168.0.241:29418/gerrittest $GERRIT_REFSPEC
git checkout FETCH_HEAD

// 运行测试或者代码规范诊断
```