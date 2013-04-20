#compass

```
Compass由SASS的核心团队成员Chris Eppstein创建，是一个非常丰富的样式框架，包括大量定义好的mixin，函数，以及对SASS的扩展。
```

###安装

```
gem install compass
compass version

// 创建工程
compass create /path/to/project
cd /path/to/project
compass watch
// Now you can edit the *.scss files in the sass directory with the text editor of your choice. the compass watch process will automatically compile your them into css in the stylesheets directory whenever they change.
```

###使用blueprint

```
compass create /path/to/project --using blueprint
cd /path/to/project
compass install blueprint
```

###配合rails

```
compass init rails /path/to/myrailsproject
compass init rails /path/to/myrailsproject --using blueprint
```

###compass的混合体的集中类型

* css3
* layout
* reset
* helpers
* typography
* utilities

// 导入
@import "compass"

比如border-radius:
// 配置
$default-border-radius 5px 
// 调用

```
.simple { 
    @include border-radius(4px, 4px); 
}
```

输出

```
 .simple {
    -webkit-border-radius: 4px 4px;
    -moz-border-radius: 4px / 4px;
    -khtml-border-radius: 4px / 4px;
    border-radius: 4px / 4px; 
}
```

Compass的函数需要慢慢熟悉使用才能掌握。