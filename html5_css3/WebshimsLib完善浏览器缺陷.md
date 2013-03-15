Webshims构建于Modernizr和jQuery之上，可用于插入表单补丁或者是其他的html5特性，当浏览器无法提供某个特性的时候，Webshims可以提供合理的jQuery解决方案，使用很简单：

```
1. 引用jquery,modernizr,polyfiller三个js文件.
2. 调用$.webshims.polyfill();
```