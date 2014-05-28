关于gerrit安装钩子的解释:

* [http://stackoverflow.com/questions/7893854/gerrit-recreating-change-ids](http://stackoverflow.com/questions/7893854/gerrit-recreating-change-ids)
* [http://gerrit.googlecode.com/svn/documentation/2.0/cmd-hook-commit-msg.html](http://gerrit.googlecode.com/svn/documentation/2.0/cmd-hook-commit-msg.html)

commit-msg hook的工作方式:

* Check if you have change-id in your commit message.
* If not, generates one.

> If you type git commit --amend and edit commit message, you still have old change-id (it is good).
But if you type git commit --amend -m "...." you have removed change-id, so gerrit generates new one.
Rule of a thumb: Don't use --amend -m with gerrit.

也就是修复提交不要加-m参数，使用git --amend即可。

如何自动的安装commit-msg钩子:

* 找到本机git的安装模板目录 which git或者whereis git帮助查找
* 将commit-msg钩子拷贝进该目录加上执行权限

```
# which git => /opt/local/bin/git
# scp -p -P 29418 wangbo@192.168.0.241:hooks/commit-msg ./
# sudo mv commit-msg /opt/local/share/git-core/templates/hooks/
```

Windows环境的目录请参考:

* C:\cygwin64\usr\share\git-core\templates\hooks\* C:\Program Files (x86)\Git\share\git-core\templates\Linux/UNIX/Mac OSX环境请参考:

* /usr/share/git-core/templates/hooks/
* /opt/local/share/git-core/templates/hooks/Linux/UNIX/Mac OSX系统请注意给commit-msg加上+x执行权限，否则钩子可能不起作用。安装完毕后可以clone任何git工程，查看.git/hooks/下面的文件确认是否有commit-msg的可执行文件。