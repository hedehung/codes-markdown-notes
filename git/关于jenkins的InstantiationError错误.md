刚装好的jenkins配置项目，可能出现`java.lang.InstantiationError`，该错误的信息如下:

```
Started by user Administrator
Building in workspace /root/.jenkins/jobs/gerrit test project/workspace
 > git rev-parse --is-inside-work-tree
Fetching changes from the remote Git repository
 > git config remote.origin.url ssh://jenkins@192.168.0.241:29418/gerrittest
Fetching upstream changes from ssh://jenkins@192.168.0.241:29418/gerrittest
 > git --version
using GIT_SSH to set credentials jenkins private key
 > git fetch --tags --progress ssh://jenkins@192.168.0.241:29418/gerrittest +refs/heads/*:refs/remotes/origin/*
Seen branch in repository origin/master
Seen 1 remote branch
Checking out Revision ffb0930edb7ce95e5373011992519b1ad264a4ed (origin/master)
 > git config core.sparsecheckout
 > git checkout -f ffb0930edb7ce95e5373011992519b1ad264a4ed
 > git rev-list ffb0930edb7ce95e5373011992519b1ad264a4ed
ERROR: Publisher hudson.plugins.gerrit.GerritNotifier aborted due to exception
java.lang.InstantiationError: org.eclipse.jgit.lib.Repository
	at hudson.plugins.gerrit.git.GitTools.getRepository(GitTools.java:24)
	at hudson.plugins.gerrit.git.GitTools.getHead(GitTools.java:48)
	at hudson.plugins.gerrit.GerritNotifier$1.invoke(GerritNotifier.java:180)
	at hudson.plugins.gerrit.GerritNotifier$1.invoke(GerritNotifier.java:171)
	at hudson.FilePath.act(FilePath.java:920)
	at hudson.FilePath.act(FilePath.java:893)
	at hudson.plugins.gerrit.GerritNotifier.perform(GerritNotifier.java:171)
	at hudson.tasks.BuildStepMonitor$3.perform(BuildStepMonitor.java:45)
	at hudson.model.AbstractBuild$AbstractBuildExecution.perform(AbstractBuild.java:745)
	at hudson.model.AbstractBuild$AbstractBuildExecution.performAllBuildSteps(AbstractBuild.java:709)
	at hudson.model.Build$BuildExecution.post2(Build.java:182)
	at hudson.model.AbstractBuild$AbstractBuildExecution.post(AbstractBuild.java:658)
	at hudson.model.Run.execute(Run.java:1731)
	at hudson.model.FreeStyleBuild.run(FreeStyleBuild.java:43)
	at hudson.model.ResourceController.execute(ResourceController.java:88)
	at hudson.model.Executor.run(Executor.java:231)
Finished: FAILURE
```

解决办法是移除jekins gerrit plugin(0.7)版本的插件。参考见[http://osdir.com/ml/java-jenkins-user/2012-02/msg00361.html](http://osdir.com/ml/java-jenkins-user/2012-02/msg00361.html)，注意点了uninstall后仅仅是`Uninstallation pending`，需要点下面的Restart按钮才可以生效。该插件是jenkins默认安装的。