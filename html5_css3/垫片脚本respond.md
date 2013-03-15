给IE6/7/8追加min和max媒体查询功能，respond.js的特点是使用简单，加在速度快。

1. 直接使用

```
<!--[if lte IE 8]>
<script src="js/respond.min.js"></script>
<![endif]-->
```

2. 搭配瑞士军刀按需加载

```
Modernizer.load({
	test: Modernizer.mq("only all"),
	nope: "js/respond.min.js"
});
```
