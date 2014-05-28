gerrit从2.6开始,默认不再添加verified category,也就是changes上就看不到verified label了。具体的原因见gerrit的[Change 44084](https://gerrit-review.googlesource.com/#/c/44084/)。这是为了简化out of the box工作流,如果需要与jenkins等CI环境集成,则需要手动添加verified category,只要在All-Projects的project.config文件里添加5行文本就可以了。

```
# git clone ssh://wangbo@192.168.0.241:29418/All-Projects
# vim project.config
```

添加以下的内容:

```
[label "Verified"]
       function = MaxWithBlock
       value = -1 Fails
       value =  0 No score
       value = +1 Verified
```

提交到远程gerrit服务器:

```
# git commit -a -m "add verified category"
# git push origin HEAD:refs/meta/config
```

如果遇到invalid author错误，就检查gerrit中的用户名和email设置，是否和git config配置，或者添加本机的git config的email地址。

如果出现权限错误，就去All-projects的access设置HEAD:refs/meta/config的push权限，或者把操作帐号加入Administrators组。

登录到Gerrit的My->Changes页面已经看到了2个标签:

* Need Code-Review
* Need Verified

Need Code-Review是自带的，Need Verified是修改All-projects工程的配置产生的节点，用于CI服务器评分。

如何修改All-projects仓库，见[http://blog.bruin.sg/2013/04/how-to-edit-the-project-config-for-all-projects-in-gerrit/](http://blog.bruin.sg/2013/04/how-to-edit-the-project-config-for-all-projects-in-gerrit/)

label-Verified的说明，见[https://gerrit-review.googlesource.com/Documentation/config-labels.html#label_Verified](https://gerrit-review.googlesource.com/Documentation/config-labels.html#label_Verified)

The range of values is:

* -1 Fails，Tried to compile, but got a compile error, or tried to run tests, but one or more tests did not pass. **Any -1 blocks submit.**
    
* 0 No score，Didn’t try to perform the verification tasks.

* +1 Verified，Compiled (and ran tests) successfully. **Any +1 enables submit.**